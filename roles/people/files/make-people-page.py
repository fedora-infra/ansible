#!/usr/bin/env python3
# -*- coding: utf-8 -*-
#
# Copyright © 2016 Chaoyi Zha <cydrobolt@fedoraproject.org>
# Copyright © 2021 Red Hat, Inc.
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

import grp
import hashlib
import logging
import pwd
from pathlib import Path

from jinja2 import Template


log = logging.getLogger(__name__)

page_jinja_template = """
<!DOCTYPE html>
<html>
<head>
    <title>Fedora People</title>
    <link rel='stylesheet' href='/static/datatables.min.css'>
    <!--<link rel='stylesheet' href='//getfedora.org/static/css/bootstrap-theme.css'>-->
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <style>
        .bg-fedora-blue {
            background: #3c6eb4;
        }

        .center {
            text-align: center;
        }

        footer {
            margin-bottom: 45px;
        }

        .user-avatar {
            display: inline;
            height: 20px;
        }
    </style>
</head>
<body>
    <div class="jumbotron bg-fedora-blue">
        <div class="container-fluid center">
            <img class="fedoralogotext" class="img-responsive center-block" src="//getfedora.org/assets/images/logos/fedora-white.png" alt="Fedora Logotext">
        </div>
    </div>
    <div class="container pagebody">
        <h3>Fedora People</h3>
        <p>A repository with web and <code>git</code> resources from the people behind Fedora.</p>
        <p class='text-muted'>
            <a target='_blank' href='//fedoraproject.org/wiki/Infrastructure/fedorapeople.org'>FAQ</a> on using your public space.
        </p>

        <table class='table table-hover' id='peopleTable' >
            <thead>
                <tr>
                    <th>Name</th>
                    <th>Public Resources</th>
                </tr>
            </thead>
            <tbody>


            {% for username, user in users %}
                <tr>
                    <td>
                        <img class='user-avatar' src='/static/grey.jpg' alt='Avatar for {{username|e}}' data-src='https://seccdn.libravatar.org/avatar/{{user['openid_hash']}}?s=20&d=retro'>
                        {{user.name.strip()|e}} <span class='text-muted'>({{username|e}})</span>
                    </td>


                    <td>
                        {% if user['has_public_git'] %}
                        <div>
                            <a href="https://fedorapeople.org/cgit/{{username|e}}/">Git repositories</a>
                        </div>
                        {% endif %}

                        {% if user['has_public_html'] %}
                        <div>
                            <a href="https://{{username|e}}.fedorapeople.org">{{username|e}}'s homepage</a>
                        </div>
                        {% endif %}
                        <div>
                            <a href="https://fedoraproject.org/wiki/user:{{username|e}}">{{username|e}}'s wiki page</a>
                        </div>
                    </td>
                </tr>
            {% endfor %}
        </tbody>
    </table>
    </div>

    <hr>

    <footer class='center text-muted'>
        <p class="copy">
            &copy; 2016 - 2021 Chaoyi Zha, Red Hat, Inc., and others.
            Please send any comments or corrections to the <a href="mailto:admin@fedoraproject.org">infrastructure team</a>.
        </p>
        <p class="disclaimer">
            The Fedora Project is maintained and driven by the community and sponsored by Red Hat.  This is a community maintained site.  Red Hat is not responsible for content.
        </p>
            <a href="http://fedoraproject.org/wiki/Legal:Main">Legal</a> &middot; <a href="http://fedoraproject.org/wiki/Legal:Trademark_guidelines">Trademark Guidelines</a>
    </footer>

    <script src='/static/jquery.dataTables.min.js'></script>
    <script src='/static/jquery.unveil.js'></script>


    <script>
        $(document).ready(function() {
            $('table').DataTable({
                'pageLength': 50,
                'initComplete': function(settings, json) {
                    $('img').unveil();
                }
            });
            $('.table').on('draw.dt', function() {
                /* on each table draw */
                $('img').unveil();
            });
        });
    </script>

</body>
</html>
"""

topdir = Path("/home/fedora")
homedirs = sorted(d for d in topdir.glob("*") if d.is_dir())

users = {}

for hdir in homedirs:
    if hdir.stat().st_uid == 0:
        log.info("'%s' is owned by root. Skipping.", hdir.name)
        continue

    try:
        owner_name = hdir.owner()
    except KeyError:
        log.warning("'%s' is not owned by a named user. Skipping.", hdir.name)
        continue

    if owner_name != hdir.name:
        log.warning("'%s' is owned by '%s'. Skipping.", hdir.name, owner_name)
        continue

    username = hdir.name
    user = {}

    try:
        pwentry = pwd.getpwnam(username)
    except KeyError:
        log.warning("User not found: %s. Skipping.", username)
        continue

    user["name"] = pwentry.pw_gecos
    try:
        user["has_public_html"] = (hdir / "public_html").is_dir()
    except PermissionError:
        user["has_public_html"] = False
    try:
        user["has_public_git"] = (hdir / "public_git").is_dir()
    except PermissionError:
        user["has_public_git"] = False
    user["email_hash"] = hashlib.md5(
        f"{user['name'].lower()}@fedoraproject.org".encode("utf-8")
    ).hexdigest()
    user["openid_hash"] = hashlib.md5(
        f"http://{user['name'].lower()}.id.fedoraproject.org/".encode("utf-8")
    ).hexdigest()

    if user["has_public_html"] or user["has_public_git"]:
        users[username] = user

page_jinja_template_obj = Template(page_jinja_template)
page_output = page_jinja_template_obj.render(users=sorted(users.items()))

out_file = Path("/srv/people/site/index.html")

# get gid for web group
out_file_grp = grp.getgrnam("web").gr_gid

with open(out_file, "w", encoding="utf-8") as handle:
    handle.write(page_output)

# The code below was present originally, however the cron job is ran under the
# `apache` user so it is not clear what this was meant to do.
# This is being kept here for convenience in case we need to re-activate this
# code, down the line this should just be removed.

# keep current owner uid
#st = out_file.stat()
#out_file_uid = st.st_uid
#
# give write permissions to group
#out_file.chmod(st.st_mode | stat.S_IWGRP)
# chown out file to group
#os.chown(out_file, out_file_uid, out_file_grp)
