# (C) 2012, Michael DeHaan, <michael.dehaan@gmail.com>
# based on the log_plays example
# skvidal@fedoraproject.org
# rbean@redhat.com
# karsten@redhat.com  changes for fedora-messaging
# abompard@redhat.com changes to adapt to ansible's specific python

# Ansible is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Ansible is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Ansible.  If not, see <http://www.gnu.org/licenses/>.

import json
import logging
import os
import pwd
import uuid
from subprocess import run, PIPE, STDOUT
from tempfile import NamedTemporaryFile

try:
    from ansible.plugins.callback import CallbackBase
except ImportError:
    # Ansible v1 compat
    CallbackBase = object

try:
    from ansible.utils.hashing import secure_hash
except ImportError:
    from ansible.utils import md5 as secure_hash

LOGGER = logging.getLogger(__name__)
FEDORA_MESSAGING_CONF = "/etc/fedora-messaging/batcave-messaging.toml"


def getlogin():
    try:
        user = os.getlogin()
    except OSError:
        user = pwd.getpwuid(os.geteuid())[0]
    return user


def send_message(msg):
    msg["id"] = str(uuid.uuid4())
    env = os.environ.copy()
    env["FEDORA_MESSAGING_CONF"] = FEDORA_MESSAGING_CONF
    with NamedTemporaryFile(mode="w+") as msg_file:
        json.dump(msg, msg_file)
        result = run(
            ["fedora-messaging", "publish", msg_file.name],
            stdout=PIPE, stderr=STDOUT, text=True, env=env,
        )
    if result.returncode > 0:
        LOGGER.warning(f"Fedora Messaging plugin failed: {result.stdout}")
        print(f"Fedora Messaging plugin failed: {result.stdout}")


class CallbackModule(CallbackBase):
    """ Publish playbook starts and stops to fedora_messaging. """

    CALLBACK_NAME = "fedora_messaging_callback"
    CALLBACK_TYPE = "notification"
    CALLBACK_VERSION = 2.0
    CALLBACK_NEEDS_WHITELIST = True

    playbook_path = None

    def __init__(self):
        self.play = None
        self.playbook = None

        super(CallbackModule, self).__init__()

    def set_play_context(self, play_context):
        self.play_context = play_context

    def v2_playbook_on_start(self, playbook):
        self.playbook = playbook

    def v2_playbook_on_play_start(self, play):
        # This gets called once for each play.. but we just issue a message once
        # for the first one.  One per "playbook"
        if not self.playbook:
            return
        # figure out where the playbook FILE is
        path = os.path.abspath(self.playbook._file_name)

        # Bail out early without publishing if we're in --check mode
        if self.play_context.check_mode:
            return

        # Only publish on playbook start
        if self.playbook_path:
            return

        msg = {
            "topic": "ansible.playbook.start",
            "body": {
                'playbook': path,
                'userid': getlogin(),
                'extra_vars': play._variable_manager.extra_vars,
                'inventory': play._variable_manager._inventory._sources,
                'playbook_checksum': secure_hash(path),
                'check': self.play_context.check_mode
            },
        }
        send_message(msg)
        self.playbook_path = path

    def v2_playbook_on_stats(self, stats):
        if not self.playbook_path:
            return

        results = dict([(h, stats.summarize(h)) for h in stats.processed])
        msg = {
            "topic": "ansible.playbook.complete",
            "body": {
                'playbook': self.playbook_path,
                'userid': getlogin(),
                'results': results
            },
        }
        send_message(msg)
