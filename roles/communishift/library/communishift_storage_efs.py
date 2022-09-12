#!/usr/bin/python

# Copyright: (c) 2018, Terry Jones <terry.jones@example.org>
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)
from __future__ import absolute_import, division, print_function

__metaclass__ = type

import boto3

DOCUMENTATION = r"""
---
module: communishift_storage_efs

short_description: Configure small selection of AWS EFS features

version_added: "0.0.1"

description: This module implements a small selection of features of the AWS EFS API to compliment the community.aws.efs module.

options:
    project_name:
        description: The name of the Communishift Project.
        required: true
        type: str
    aws_access_key_id:
        description: The AWS API access_key_id.
        required: true
        type: str
    aws_secret_access_key:
        description: The AWS API secret_access_key.
        required: true
        type: str
    aws_region:
        description: The AWS Region where the EFS resources are being created.
        required: true
        type: str
    aws_efs_filesystem_id:
        description: The AWS EFS FileSystemId of the resource that was previously created.
        required: true
        type: str

author:
    - David Kirwan (dkirwan@redhat.com)
    - Lenka Segura (lsegura@redhat.com)
    - Patrik Polakovic (ppolakov@redhat.com)
"""

EXAMPLES = r"""
- name: Create the EFS AccessPoint
  communishift_storage_efs:
    project_name: "{{ communishift_project_name }}"
    aws_access_key_id: "{{ communishift_efs_access_key }}"
    aws_secret_access_key: "{{ communishift_efs_secret_key }}"
    aws_region: "{{ communishift_region }}"
    aws_efs_filesystem_id: >-
      {{create_efs_filesystem_response['efs']['file_system_id']}}
  register: create_efs_accesspoint_response
  ignore_errors: true
"""

RETURN = r"""

# These are examples of possible return values, and in general should use other names for return values.
accesspoint_id:
    description: The AccessPointId returned by the AWS EFS API creation request.
    type: str
    returned: If the EFS Filesystem exists and the AccessPoint been successfully created or already exists.
    sample: 'fsap-0938462b9b5f77388'
full_response:
    description: The response returned by the AWS EFS boto3 client.create_access_point() or client.describe_access_points().
    type: str
    returned: If the EFS Filesystem exists and the AccessPoint has been successfully created or already exists.
    sample: '{'ResponseMetadata': {'RequestId': '9c3d3e41-4332-4fe3-8388-f04ccf0400a2', 'HTTPStatusCode': 200, 'HTTPHeaders': {'x-amzn-requ
estid': '9c3d3e41-4332-4fe3-8388-f04ccf0400a2', 'content-type': 'application/json', 'content-length': '503', 'date': 'Tue, 16
Aug 2022 10:17:43 GMT'}, 'RetryAttempts': 0}, 'ClientToken': 'communishift_storage_efs', 'Tags': [{'Key': 'communishift', 'Val
ue': 'projectname'}], 'AccessPointId': 'fsap-0938462b9b5f77388', 'AccessPointArn': 'arn:aws:elasticfilesystem:us-east-1:XXXXXXXXXXXX:
access-point/fsap-0938462b9b5f77388', 'FileSystemId': 'fs-0343e73f7765a503b', 'PosixUser': {'Uid': 50000, 'Gid': 50000}
, 'RootDirectory': {'Path': '/', 'CreationInfo': {'OwnerUid': 50000, 'OwnerGid': 50000, 'Permissions': '775'}}, 'OwnerId': 'XXXX',
'LifeCycleState': 'creating'}'
msg:
    description: The output message that the module generates.
    type: str
    returned: always
    sample: 'AWS EFS AccessPoint already exists.'
"""

from ansible.module_utils.basic import AnsibleModule


def run_module():
    # define available arguments/parameters a user can pass to the module
    module_args = dict(
        project_name=dict(type="str", required=True),
        aws_access_key_id=dict(type="str", required=True),
        aws_secret_access_key=dict(type="str", required=True),
        aws_region=dict(type="str", required=True),
        aws_efs_filesystem_id=dict(type="str", required=True),
    )

    # seed the result dict in the object
    # we primarily care about changed and state
    # changed is if this module effectively modified the target
    # state will include any data that you want your module to pass back
    # for consumption, for example, in a subsequent task
    result = dict(changed=False, accesspoint_id="", full_response="", msg="")

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

    efs_client = boto3.client(
        "efs",
        aws_access_key_id=module.params["aws_access_key_id"],
        aws_secret_access_key=module.params["aws_secret_access_key"],
        region_name=module.params["aws_region"],
    )

    try:
        response = efs_client.create_access_point(
            ClientToken=module.params["project_name"],
            Tags=[
                {"Key": "communishift", "Value": module.params["project_name"]},
                {"Key": "Name", "Value": module.params["project_name"]},
            ],
            FileSystemId=module.params["aws_efs_filesystem_id"],
            PosixUser={
                "Uid": 1001,
                "Gid": 1001,
                "SecondaryGids": [ 0 ],
            },
            RootDirectory={
                "Path": f"/{ module.params['project_name'] }",
                "CreationInfo": {
                    "OwnerUid": 0,
                    "OwnerGid": 0,
                    "Permissions": "777",
                },
            },
        )

        result["accesspoint_id"] = response["AccessPointId"]
        result["full_response"] = response
        result["changed"] = True
        result["msg"] = "AWS EFS AccessPoint created successfully."
        module.exit_json(**result)
    except efs_client.exceptions.AccessPointAlreadyExists:
        response = efs_client.describe_access_points(
            FileSystemId=module.params["aws_efs_filesystem_id"]
        )
        result["accesspoint_id"] = response["AccessPoints"][0]["AccessPointId"]
        result["full_response"] = response
        result["msg"] = "AWS EFS AccessPoint already exists."
        module.fail_json(**result)


def main():
    run_module()


if __name__ == "__main__":
    main()
