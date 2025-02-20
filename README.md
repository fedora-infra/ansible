Fedora Infrastructure
=====================

Welcome! This is the Fedora Infrastructure Ansible Pagure project.

Pull requests and forks can be made against this repository hosted
at https://pagure.io/fedora-infra/ansible

This repository is also mirrored for production runs to
https://infrastructure.fedoraproject.org/infra/ansible/
but this is the working repository where changes are made.

If you would like to help out with Fedora Infrastructure, see:

* https://docs.fedoraproject.org/en-US/infra/gettingstarted/
* https://docs.fedoraproject.org/en-US/infra/apprentice/

Ansible repository/structure
----------------------------

```
files - files and templates for use in playbooks/tasks
      - subdirs for specific tasks/dirs highly recommended

inventory - where the inventory and additional vars is stored
          - All files in this directory in ini format
          - added together for total inventory
  group_vars:
          - per group variables set here in a file per group
  host_vars:
          - per host variables set here in a file per host

library - library of custom local ansible modules

playbooks - collections of plays we want to run on systems

  groups: groups of hosts configured from one playbook.

  hosts: playbooks for single hosts.

  manual: playbooks that are only run manually by an admin as needed.

tasks - snippets of tasks that should be included in plays

roles - specific roles to be use in playbooks.
        Each role has it's own files/templates/vars

filter_plugins - Jinja filters

main.yml - This is the main playbook, consisting of all
             current group and host playbooks. Note that the
             daily cron doesn't run this, it runs even over
             playbooks that are not yet included in main.
             This playbook is usefull for making changes over
             multiple groups/hosts usually with -t (tag).
```

Paths
-----

The public path on batcave01 (our control host) for everything is `/srv/web/infra/ansible`

The private path on batcave01 (our control host) (which is sysadmin-main accessible only)
is `/srv/private/ansible`

In general to run any ansible playbook you will want to run:

```
sudo -i ansible-playbook /path/to/playbook.yml
```

(On batcave01, our control host)

Scheduled check-diff
--------------------

Every night a cron job runs over all playbooks under `playbooks/{groups}{hosts}`
with `ansible --check --diff`. A report from this is sent to sysadmin-logs.
In the ideal state this report would be empty.

Idempotency
-----------

All playbooks should be idempotent. Ie, if run once they should bring the
machine(s) to the desired state, and if run again N times after that they should
make 0 changes (because the machine(s) are in the desired state).
Please make sure your playbooks are idempotent.

Can be run anytime
------------------

When a playbook or change is checked into ansible you should assume
that it could be run at ***ANY TIME***. Always make sure the checked in state
is the desired state. Always test changes when they land so they don't
surprise you later.

Contributing and Licensing
--------------------------

Contributions to this repository are subject to the Fedora Project
Contributor Agreement. If no license is specified, the MIT license is used, otherwise
the contribution is under the specified acceptable Fedora License.
See https://docs.fedoraproject.org/en-US/legal/fpca/
for more information.

Contributing Pull Requests
--------------------------

If found a way to improve this repository or fix an issue found in our
infrastructure tracker (see https://pagure.io/fedora-infrastructure/issues)
open a pull-request.

You either should have capability to run the playbooks after they have been reviewed,
and merged or find the person responsible and work with them to make sure the changes
will be aplied afterwards. 

We are currently working on a simple to use list of Point Of Contanct people for the applications
here, untill it is done, you can, look at people that recently edited the ansible files,
or if you belong to sysadmin group, view the /etc/ansible_utils/rbac.yaml located on batcave01,
where you can see the groups of people that have capabilities to run the relevant playbooks.

For example, to upgrade Release Monitoring, you need to run playbook openshift-apps/release-monitoring.yaml.
People in sysadmin-releasemonitoring have that capability, and you cand find the members in https://accounts.fedoraproject.org/group/sysadmin-releasemonitoring/

If the application in question is not on the critical path it should be sufficient,
if person responsible for the application reviews the PR.

If the files in question are on the critical path, that are necessary for functioning packager workflow,
at least two different people should review the PR.

If there is any risk at all, that the application of the changes would induce downtime,
work closely with other to ensure that the downtime is properly scheduled:

- there is an issue in https://pagure.io/fedora-infrastructure/issues specifying the downtime
- there is an email sent to the devel-list
- https://status.fedoraproject.org is updated (see https://docs.fedoraproject.org/en-US/infra/sysadmin_guide/status-fedora/)

Applications on critical path: pagure, mirrormanager, toddlers, bodhi, noggin, mdapi, rpmautospec, 
pagure-dist-git, mirror_from_pagure, fedora-messaging, dist-git, PDC/FPDC, FMN, sigul
robosignatory, tag2distrepo, ci-resultsdb-listener, stylo, mirrorlist
resultsdb, Nagios, koschei, wiki / mediawiki, wiki / moin, waiverdb, 
greenwave, ODCS, Mailman3 / HK, mailman 2, OSBS, pungi, koji, MBS, 
IPA, rabbitmq, geoip,ipsilon
