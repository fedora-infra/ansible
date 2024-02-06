#!/bin/sh

# Run data only backups daily and only keep a certain number of old backups.

KEEP=7

ls -1d /var/lib/ipa/backup/ipa-data-* | head -n -${KEEP} | xargs rm -rf
/usr/sbin/ipa-backup --data --online --quiet
