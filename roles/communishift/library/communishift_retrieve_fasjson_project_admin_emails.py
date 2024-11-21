#!/usr/bin/python

from __future__ import absolute_import, division, print_function

import json
import re
import requests

from ansible.module_utils.basic import AnsibleModule
from requests_kerberos import HTTPKerberosAuth

__metaclass__ = type

DOCUMENTATION = r"""
---
module: communishift_retrieve_fasjson_project_admin_emails

short_description: Retrieve fasjson user emails.

version_added: "0.0.1"

description: This module retrieves fasjson user email data which match a
particular group name pattern. eg groups which start with "^communishift-".

options:
    keytab_path:
        description: This is the location on disk where the kerberos keytab is stored.
        required: true
        type: str
    principal:
        description: The is the kerberos principal.
        required: true
        type: str
    group_name_pattern:
        description: This is the python regex string search pattern to filter on group names.
        required: true
        type: str

author:
    - David Kirwan (dkirwan@redhat.com)
"""

EXAMPLES = r"""
- name: Retrieve fasjson group/user data based on pattern supplied
  communishift_retrieve_fasjson_project_admin_emails:
    keytab_path: "{{ communishift_keytab }}"
    principal: "{{ communishift_principal }}"
    group_name_pattern: "{{ communishift_group_regex_pattern }}"
  register: communishift_project_emails_fasjson_response
"""

RETURN = r"""
# These are examples of possible return values, and in general should use other names for return
# values.
matched_groups:
    description: The groups and their users which match the regex pattern supplied.
    type: str
    returned: always
    sample:
[
  {
    "group_name": "communishift-yyy",
    "group_members": [
      {"username": "user1": {"emails": ["user1@gmail.com"]}},
      {"username": "user2": {"emails": ["user2@gmail.com"]}},
      {"username": "user3": {"emails": ["user3@gmail.com"]}},
      {"username": "user4": {"emails": ["user4@gmail.com"]}}
    ]
  },
  {
    "group_name": "communishift-abc",
    "group_members": [
      {"username": "user1": {"emails": ["user1@gmail.com"]}},
      {"username": "user3": {"emails": ["user3@gmail.com"]}},
      {"username": "user7": {"emails": ["user7@gmail.com"]}},
      {"username": "user9": {"emails": ["user9@gmail.com"]}}
    ]
  }
]

msg:
    description: The output message that the module generates.
    type: str
    returned: always
    sample: 'Successfully retrieved groups and their users emails from fasjson.'
"""


# Helper function to create the http requests
def get_http_client(keytab_path, principal):
    try:
        kerberos_auth = HTTPKerberosAuth(principal=principal)
    except Exception as e:
        print("Error trying to authenticate with Kerberos", e)
        raise
    session = requests.Session()
    session.auth = kerberos_auth
    return session


# Helper function to retrieve fasjson groups
def get_groups(http_client):
    response = http_client.get("%sgroups/" % ("https://fasjson.fedoraproject.org/v1/"))
    if response.ok:
        return response.json()


# Helper function to retrieve fasjson group members
def get_group_members(http_client, groupname):
    response = http_client.get(
        "%sgroups/%s/members/" % ("https://fasjson.fedoraproject.org/v1/", groupname)
    )
    if response.ok:
        return response.json()

# Helper function to retrieve fasjson group member data
def get_group_member_data(http_client, group_member_name):
    response = http_client.get(
        "%susers/%s/" % ("https://fasjson.fedoraproject.org/v1/", group_member_name)
    )
    if response.ok:
        return response.json()

def run_module():
    # define available arguments/parameters a user can pass to the module
    module_args = dict(
        keytab_path=dict(type="str", required=True),
        principal=dict(type="str", required=True),
        group_name_pattern=dict(type="str", required=True),
    )

    # seed the result dict in the object
    # we primarily care about changed and state
    # changed is if this module effectively modified the target
    # state will include any data that you want your module to pass back
    # for consumption, for example, in a subsequent task
    result = dict(changed=False, original_message="", message="")

    # the AnsibleModule object will be our abstraction working with Ansible
    # this includes instantiation, a couple of common attr would be the
    # args/params passed to the execution, as well as if the module
    # supports check mode
    module = AnsibleModule(argument_spec=module_args, supports_check_mode=True)

    # if the user is working with this module in only check mode we do not
    # want to make any changes to the environment, just return the current
    # state with no modifications
    if module.check_mode:
        module.exit_json(**result)

    # manipulate or modify the state as needed (this is going to be the
    # part where your module will do what it needs to do)
    keytab_path = module.params["keytab_path"]
    principal = module.params["principal"]
    group_name_pattern = module.params["group_name_pattern"]

    try:
        http_client = get_http_client(keytab_path, principal)
        groups_response = get_groups(http_client)
        # print(json.dumps(groups_response))

        communishift_groups = []
        regexp = re.compile(r"%s" % (group_name_pattern))
        for v in groups_response["result"]:
            if regexp.search(v["groupname"]):
                group = {"groupname": v["groupname"], "groupmembers": []}

                group_member_res = get_group_members(http_client, v["groupname"])
                # print(json.dumps(group_member_res))

                for v in group_member_res["result"]:
                    user_data_res = get_group_member_data(http_client, v["username"])
                    # user_data_res["result"]["emails"] contains {"user1": {"emails": ["user1@gmail.com"]}}
                    u = {"username": v["username"], "emails": user_data_res["result"]["emails"]}
                    group["groupmembers"].append(u)
                communishift_groups.append(group)
                # print(v["groupname"])

        # print(json.dumps(communishift_groups))

        result["matched_groups"] = json.dumps(communishift_groups)
        result["changed"] = True
        result["msg"] = "Successfully retrieved groups and their users from fasjson."
    except Exception:
        raise

    # in the event of a successful module execution, you will want to
    # simple AnsibleModule.exit_json(), passing the key/value results
    module.exit_json(**result)


def main():
    run_module()


if __name__ == "__main__":
    main()
