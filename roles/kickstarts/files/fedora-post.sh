#!/bin/bash
# This script gets run on every host after the kickstart runs.

infraurl="https://infrastructure.fedoraproject.org"

# suck down a root ssh key from our central location
mkdir -p /root/.ssh
chmod 700 /root/.ssh
curl -o /root/.ssh/authorized_keys $infraurl/infra/ssh/admin.pub

#
# setup our sshd_config
#
curl -o /etc/ssh/sshd_config $infraurl/infra/ssh/sshd_config.default 
restorecon -Rv /etc/ssh

# we don't want /tmp tmpfs
systemctl mask tmp.mount

systemctl start postfix

echo "$HOSTNAME has just been [re]installed" |/bin/mail -s "$HOSTNAME - INSTALLED" -r admin@fedoraproject.org admin@fedoraproject.org

mkdir -p /etc/ansible/facts.d
date +%Y%m%d > /etc/ansible/facts.d/install_date.fact
