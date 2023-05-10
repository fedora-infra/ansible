#!/usr/bin/env python3

from distutils.sysconfig import get_python_lib

from ansible.module_utils.basic import AnsibleModule


DOCUMENTATION = r'''
---
module: python3_fact

short_description: Add Ansible facts about the Python3 installation

# If this is part of a collection, you need to use semantic versioning,
# i.e. the version is of the form "2.5.0" and not "2.4".
version_added: "1.0.0"

description: Ansible facts will be added about the following Python3

author:
    - Aurelien Bompard (@abompard)
'''

EXAMPLES = r'''
# In ansible.cfg

facts_modules = smart, python3_fact

# Ansible facts dump:

$ ansible -m debug -a var=ansible_facts hostname
"ansible_facts": {
    ...
    "python3": {
        "sitelib": "/usr/lib/python3.11/site-packages"
    },
    ...
}
'''

RETURN = r'''
sitelib:
    description: The full path to the site-packages directory.
    type: str
    returned: always
    sample: '/usr/lib/python3.11/site-packages'
'''


def run_module():
    result = {
        "sitelib": get_python_lib(),
    }
    module = AnsibleModule(
        argument_spec={},
        supports_check_mode=True
    )
    module.exit_json(changed=False, ansible_facts=dict(python3=result))


def main():
    run_module()


if __name__ == '__main__':
    main()
