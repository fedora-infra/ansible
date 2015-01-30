# Koji callback for sending notifications about events to the fedmsg messagebus
# Copyright (c) 2009-2012 Red Hat, Inc.
#
# Authors:
#     Ralph Bean <rbean@redhat.com>
#     Mike Bonnet <mikeb@redhat.com>

from koji.plugin import callbacks
from koji.plugin import callback
from koji.plugin import ignore_error

import fedmsg
import kojihub
import re

import pprint

# Talk to the fedmsg-relay
fedmsg.init(name='relay_inbound', cert_prefix='koji', active=True)

MAX_KEY_LENGTH = 255


def camel_to_dots(name):
    s1 = re.sub('(.)([A-Z][a-z]+)', r'\1.\2', name)
    return re.sub('([a-z0-9])([A-Z])', r'\1.\2', s1).lower()


def get_message_body(topic, *args, **kws):
    msg = {}

    if topic == 'package.list.change':
        msg['tag'] = kws['tag']['name']
        msg['package'] = kws['package']['name']
    elif topic == 'task.state.change':
        info = kws['info']

        # Stuff in information about descendant tasks
        task = kojihub.Task(info['id'])
        info['children'] = task.getChildren()

        # Send the whole info dict along because it might have useful info.
        # For instance, it contains the mention of what format createAppliance
        # is using (raw or qcow2).
        msg['info'] = info
        msg['method'] = kws['info']['method']
        msg['attribute'] = kws['attribute']
        msg['old'] = kws['old']
        msg['new'] = kws['new']
        msg['id'] = kws['info']['id']

        # extract a useful identifier from the request string
        request = kws.get('info', {}).get('request', ['/'])
        msg['srpm'] = request[0].split('/')[-1]

        if 'owner_name' in info:
            msg['owner'] = info['owner_name']
        elif 'owner_id' in info:
            msg['owner'] = kojihub.get_user(info['owner_id'])['name']
        elif 'owner' in info:
            msg['owner'] = kojihub.get_user(info['owner'])['name']
        else:
            msg['owner'] = None

    elif topic == 'build.state.change':
        info = kws['info']
        msg['name'] = info['name']
        msg['version'] = info['version']
        msg['release'] = info['release']
        msg['attribute'] = kws['attribute']
        msg['old'] = kws['old']
        msg['new'] = kws['new']
        msg['build_id'] = info.get('id', None)
        msg['task_id'] = info.get('task_id', None)

        if 'owner_name' in info:
            msg['owner'] = info['owner_name']
        elif 'owner_id' in info:
            msg['owner'] = kojihub.get_user(info['owner_id'])['name']
        elif 'owner' in info:
            msg['owner'] = kojihub.get_user(info['owner'])['name']
        else:
            msg['owner'] = None

    elif topic == 'import':
        # TODO -- import is currently unused.
        # Should we remove it?
        msg['type'] = kws['type']
    elif topic in ('tag', 'untag'):
        msg['tag'] = kws['tag']['name']
        build = kws['build']
        msg['name'] = build['name']
        msg['version'] = build['version']
        msg['release'] = build['release']
        msg['user'] = kws['user']['name']
        msg['owner'] = kojihub.get_user(kws['build']['owner_id'])['name']
        msg['tag_id'] = kws['tag']['id']
        msg['build_id'] = kws['build']['id']
    elif topic == 'repo.init':
        msg['tag'] = kws['tag']['name']
        msg['tag_id'] = kws['tag']['id']
        msg['repo_id'] = kws['repo_id']
    elif topic == 'repo.done':
        msg['tag'] = kws['repo']['tag_name']
        msg['tag_id'] = kws['repo']['tag_id']
        msg['repo_id'] = kws['repo']['id']
    elif topic == 'rpm.sign':
        msg['attribute'] = kws['attribute']
        msg['old'] = kws['old']
        msg['new'] = kws['new']
        msg['info'] = kws['info']

    return msg


# This callback gets run for every koji event that starts with "post"
@callback(*[
    c for c in callbacks.keys()
    if c.startswith('post') and c not in [
        'postImport', # This is kind of useless; also noisy.
    ]
])
@ignore_error
def send_message(cbtype, *args, **kws):
    if cbtype.startswith('post'):
        msgtype = cbtype[4:]
    else:
        msgtype = cbtype[3:]

    # Short-circuit ourselves for task events.  They are very spammy and we are
    # only interested in state changes to scratch builds (parent tasks).
    if cbtype == 'postTaskStateChange':
        # only state changes
        if not kws.get('attribute', None) == 'state':
            return
        # only parent tasks
        if kws.get('info', {}).get('parent'):
            return
        # only scratch builds
        request = kws.get('info', {}).get('request', [{}])[-1]
        if not isinstance(request, dict) or not request.get('scratch'):
            return

    topic = camel_to_dots(msgtype)
    body = get_message_body(topic, *args, **kws)

    # We need this to distinguish between messages from primary koji
    # and the secondary hubs off for s390 and ppc.
    body['instance'] = 'primary'

    # Don't publish these uninformative rpm.sign messages if there's no actual
    # sigkey present.  Koji apparently adds a dummy sig value when rpms are
    # first imported and there's no need to spam the world about that.
    if topic == 'rpm.sign' and body.get('info', {}).get('sigkey') == '':
        return

    # Last thing to do before publishing: scrub some problematic fields
    # These fields are floating points which get json-encoded differently on
    # rhel and fedora.
    problem_fields = ['weight', 'start_ts', 'create_ts', 'completion_ts']
    def scrub(obj):
        if isinstance(obj, list):
            return [scrub(item) for item in obj]
        if isinstance(obj, dict):
            return dict([
                (k, scrub(v)) for k, v in obj.items() if k not in problem_fields
            ])
        return obj

    body = scrub(body)

    fedmsg.publish(topic=topic, msg=body, modname='buildsys')
