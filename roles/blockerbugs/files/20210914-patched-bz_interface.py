# Copyright 2012, Red Hat, Inc
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along
# with this program; if not, write to the Free Software Foundation, Inc.,
# 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
#
# Authors:
#   Tim Flink <tflink@redhat.com>

"""Common methods for obtaining blocker/FE information from Bugzilla"""

import logging
import datetime
from typing import Optional, Any

import bugzilla
from bugzilla.bug import Bug as bzBug
from xmlrpc.client import Fault

from blockerbugs import app

# rhbz has been updated to have a max of 20 results returned
BUGZILLA_QUERY_LIMIT = 20

base_query = {'o1': 'anywords',
              'f1': 'blocked',
              'query_format': 'advanced',
              'extra_fields': ['flags'],
              'limit': BUGZILLA_QUERY_LIMIT}

class BZInterfaceError(Exception):
    """A custom wrapper for XMLRPC errors from Bugzilla"""

    def __init__(self, msg):
        self.msg = msg

    def __str__(self):
        return repr(self.msg)


class BlockerBugs():
    """The main class for querying Bugzilla"""

    def __init__(self, user: Optional[str] = None, password: Optional[str] = None,
                 url: Optional[str] = 'https://bugzilla.redhat.com/xmlrpc.cgi',
                 bz: Optional[bugzilla.Bugzilla] = None,
                 logger: Optional[logging.Logger] = None) -> None:
        """:param user: Username to log in as. Use `None` for anonymous access.
           :param password: User password. Use `None` for anonymous access.
           :param url: Bugzilla API url.
           :param bz: `Bugzilla` instance. Created automatically if not provided. If provided,
                      the `user`, `password` and `url` values are ignored.
           :param logger: A custom `Logger` instance. Otherwise a default Logger is created.
        """
        self.logger = logger or logging.getLogger('bz_interface')
        self.bz: bugzilla.Bugzilla = bz
        if not bz:
            if not (user and password):
                self.bz = bugzilla.Bugzilla(url=url,
                                            cookiefile=None,
                                            tokenfile=None)
            else:
                self.bz = bugzilla.Bugzilla(url=url,
                                            user=user,
                                            password=password,
                                            cookiefile=None,
                                            tokenfile=None)
        self.logger.info('Using bugzilla URL: %s' % url)

    # https://bugzilla.stage.redhat.com/buglist.cgi?bug_status=NEW&bug_status=ASSIGNED
    # &bug_status=POST&bug_status=MODIFIED&classification=Fedora&component=anaconda&f1=component
    # &o1=changedafter&product=Fedora&query_format=advanced&v1=2013-03-21%2012%3A25&version=19
    def get_bz_query(self, tracker: int, last_update: datetime.datetime = None, offset: int = 0
                     ) -> dict[str, Any]:
        """Build a Bugzilla query to retrieve all necessary info about all bugs which block the
        `tracker` bug.

        :param last_update: If provided, the query is modified to ask only about bugs which have
                            recent modifications; otherwise asks about all bugs.
        :offset: offset to the query instead of just getting the first N results
        :returns: a dict which can be fed into `bugzilla.Bugzilla.query()`.
        """
        query = {}
        query.update(base_query)
        query['v1'] = str(tracker)

        if last_update:
            last_update_string = last_update.strftime("%Y-%m-%d %H:%M GMT")

            # Since this is kind of confusing, the idea here is to only grab only
            # the bugs whose whiteboard, blocks or dependson has changed since
            # the last sync or any bugs that have been created in the last day.

            # keep in mind that OP -> open parenthesis, CP -> closed parenthesis
            # and the OR is to make sure that a bug is returned if ANY of the
            # changed after conditions are met

            # FIXME: This seems to be tremendously slowing down Bugzilla5
            # Related: https://pagure.io/fedora-qa/blockerbugs/issue/184
            query.update({
                'f2': 'OP',
                'j2': 'OR',
                'f3': 'blocked',
                'o3': 'changedafter',
                'v3': last_update_string,
                'f4': 'status_whiteboard',
                'o4': 'changedafter',
                'v4': last_update_string,
                'f5': 'bug_status',
                'o5': 'changedafter',
                'v5': last_update_string,
                'f6': 'dependson',
                'o6': 'changedafter',
                'v6': last_update_string,
                'f7': 'creation_ts',
                'o7': 'greaterthaneq',
                'v7': last_update_string,
                'f8': 'short_desc',
                'o8': 'changedafter',
                'v8': last_update_string,
                'f9': 'component',
                'o9': 'changedafter',
                'v9': last_update_string,
                'f10': 'CP'
            })

        # update query with the offset to use, no change in behavior if the default 0 is used
        query.update({'offset': offset})

        return query

    def query_tracker(self, tracker: int, last_update: Optional[datetime.datetime] = None
                      ) -> list[bzBug]:
        """Perform a Bugzilla query and retrieve all necessary info about all bugs which block the
        `tracker` bug (i.e. Blocker or FE bugs).

        :param last_update: If provided, the query is modified to ask only about bugs which have
                            recent modifications; otherwise asks about all bugs.
        """

        buglist = []
        last_query_len = BUGZILLA_QUERY_LIMIT


        # this is a hotfix hack to work around the sudden config change in rhbz where the max
        # number of bugs returned for a query is 20
        # it seems to be working for now but may need more work going forward
        while last_query_len == BUGZILLA_QUERY_LIMIT:

            new_query = self.get_bz_query(tracker, last_update, offset=len(buglist))
            new_buglist = self.bz.query(new_query)
            buglist.extend(new_buglist)
            last_query_len = len(new_buglist)

        return buglist

    def query_prioritized(self) -> list[bzBug]:
        """Perform a Bugzilla query and retrieve all necessary info about all Prioritized bugs."""
        # https://bugzilla.redhat.com/buglist.cgi?bug_status=__open__&
        # f1=flagtypes.name&o1=substring&query_format=advanced&v1=fedora_prioritized_bug%2B
        query = self.bz.url_to_query(
            "{}buglist.cgi?bug_status=__open__&f1=flagtypes.name&o1=substring"
            "&query_format=advanced&v1=fedora_prioritized_bug%2B".format(
                app.config['BUGZILLA_URL']))
        buglist = self.bz.query(query)
        return buglist

    def get_deps(self, bugid: int) -> list[int]:
        """Retrieve bug dependencies.

        :returns: A list of ticket numbers which `bugid` depends on.
        """
        return self.bz.getbug(bugid).dependson


class BlockerProposal():
    def __init__(self, bz, bugid, trackers, is_blocker=False, is_fe=False, bz_user=''):
        self.bz = bz
        self.bugid = bugid
        self.trackers = trackers
        self.is_blocker = is_blocker
        self.is_fe = is_fe
        self.bz_user = bz_user
        self.bugid_ok = False
        self.proposal_ok = False
        self.bugdata = None
        self.blocks = None

        self.log = logging.getLogger('bz_interface.bugproposal')

    def get_bugdata(self):
        # get bug data, will raise XMLRPC fault if the bug does not exist
        try:
            self.bugdata = self.bz.getbug(self.bugid)
        except Fault as e:
            if e.faultCode == 101:
                raise BZInterfaceError(e.faultString)
            else:
                raise

    def get_tracker_type(self):
        if self.is_blocker and self.is_fe:
            return 'Blocker and Freeze Exception'
        if self.is_blocker:
            return 'Blocker'
        if self.is_fe:
            return 'Freeze Exception'
        if self.is_prioritized:
            return 'PrioritizedBug'

    def propose_bugs(self, bz_user, milestone_name, justification):
        comment = ['Proposed as a', self.get_tracker_type(), 'for', milestone_name, 'by',
                   bz_user, 'using the blocker tracking app because:\n\n',
                   justification]
        tracker_bugs = []
        if self.is_blocker:
            tracker_bugs.append(self.trackers['blocker'])
        if self.is_fe:
            tracker_bugs.append(self.trackers['fe'])
        self.log.info('comment: %s' % comment)
        try:
            self._do_proposal(tracker_bugs, self.bugid, ' '.join(comment), self.bz_user)
        except Fault as e:
            if e.faultCode == 51:
                # bugzilla account does not exist, this should happen very rarely, if ever
                # so just redo the call with nothing to add to cc
                # TODO - it might be useful to ask the user to re-associate accounts again here
                self._do_proposal(tracker_bugs, self.bugid, ' '.join(comment), '')
            else:
                raise BZInterfaceError(e.faultString)

    def _do_proposal(self, tracker, proposed_bugid, comment, bz_user):
        bug_update = self.bz.build_update(blocks_add=tracker,
                                          cc_add=[bz_user],
                                          comment=comment)
        self.bz.update_bugs(proposed_bugid, bug_update)

    def check_proposed_bug(self):
        if not self.bugdata:
            self.get_bugdata()

        # check to make sure that bug is not already CLOSED
        bug_status = self.bugdata.bug_status
        if 'CLOSED' in bug_status.split():
            raise BZInterfaceError('Bug %i is CLOSED: %s' % (self.bugid, bug_status))

    def get_blocks(self):
        if not self.bugdata:
            self.get_bugdata()
        self.blocks = self.bugdata.blocked

    def check_blocker_proposal(self):
        if not self.blocks:
            self.get_blocks()

        if self.trackers['blocker'] in self.blocks:
            return False
        return True

    def check_fe_proposal(self):
        if not self.blocks:
            self.get_blocks()

        if self.trackers['fe'] in self.blocks:
            return False
        return True
