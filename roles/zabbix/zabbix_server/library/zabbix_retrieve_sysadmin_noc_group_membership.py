#!/usr/bin/python

# Copyright: (c) 2018, Terry Jones <terry.jones@example.org>
# GNU General Public License v3.0+ (see COPYING or
# https://www.gnu.org/licenses/gpl-3.0.txt)
from __future__ import absolute_import, division, print_function

import json
import requests

from ansible.module_utils.basic import AnsibleModule
from requests_kerberos import HTTPKerberosAuth

__metaclass__ = type

DOCUMENTATION = r"""
---
module: zabbix_retrieve_sysadmin_noc_group_membership

short_description: Retrieve fasjson sysadmin-noc group membership from FAS then sync to Zabbix.

version_added: "0.0.1"

description: This module retrieves fasjson group membership data for the sysadmin-noc group, then
synchronises to the Zabbix server.

options:
    keytab_path:
        description: This is the location on disk where the kerberos keytab is stored.
        required: true
        type: str
    principal:
        description: The is the kerberos principal.
        required: true
        type: str
    fasjson_host:
        description: The is the fasjson hostname.
        required: true
        type: str
    group_name:
        description: This is the group name to search fasjson for.
        required: true
        type: str

author:
    - David Kirwan (dkirwan@redhat.com)
"""

EXAMPLES = r"""
- name: Retrieve fasjson group membership
  zabbix_retrieve_sysadmin_noc_group_membership:
    keytab_path: "{{ kerberos_keytab_path }}"
    principal: "{{ kerberos_principal }}"
    fasjson_host: "{{ fasjson_host }}"
    group_name: "{{ fasjson_group_name }}"
  register: fasjson_response
"""

RETURN = r"""
# These are examples of possible return values, and in general should use other names for return
# values.
group:
    description: The groups and their users which match the regex pattern supplied.
    type: str
    returned: always
    sample:
[
  {
    "group_name": "communishift-yyy",
    "group_members": [
      "uuu",
      "iii",
      "eee",
      "zqq"
    ]
  }
]

msg:
    description: The output message that the module generates.
    type: str
    returned: always
    sample: 'Successfully retrieved group membership from fasjson.'
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


# Helper function to retrieve fasjson group members
def get_group_members(http_client, fasjson_host, group_name):
    response = http_client.get(
        "https://%s/v1/groups/%s/members/" % (fasjson_host, group_name)
    )
    if response.ok:
        return response.json()


def run_module():
    # define available arguments/parameters a user can pass to the module
    module_args = dict(
        keytab_path=dict(type="str", required=True),
        principal=dict(type="str", required=True),
        fasjson_host=dict(type="str", required=True),
        group_name=dict(type="str", required=True),
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
    fasjson_host = module.params["fasjson_host"]
    group_name = module.params["group_name"]

    try:
        http_client = get_http_client(keytab_path, principal)

        group = {"groupname": group_name, "groupmembers": []}
        group_member_res = get_group_members(http_client, fasjson_host, group_name)
        # print(json.dumps(group_member_res))

        for i in group_member_res["result"]:
            group["groupmembers"].append(i["username"])

        result["group"] = json.dumps(group)
        result["changed"] = True
        result["msg"] = "Successfully retrieved group membership from fasjson."
    except Exception:
        raise

    # in the event of a successful module execution, you will want to
    # simple AnsibleModule.exit_json(), passing the key/value results
    module.exit_json(**result)


def main():
    run_module()


if __name__ == "__main__":
    main()
