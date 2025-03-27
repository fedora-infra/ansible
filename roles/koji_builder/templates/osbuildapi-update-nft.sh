#!/bin/bash

#  Allow koji builders to speak to api.openshift.com or api.stage.openshift.com
#  Also allow them to speak to sso.redhat.com
#  Works by adding the IPs to a set "osbuildapi" in the nft table "ip filter"
# then the nft rules for the host use that set to allow traffic.

#  Unlike iptables we don't create the set here, because it's created as the
# nftables service starts ... so it's possible we run this script and the set
# isn't created yet (possibly means nftables service isn't up yet, but more
# likely it isn't configured as an osbuild machine).
#  So that leaves a few options:
#    1. Checking if it exists and exiting quietly, if it doesn't.
#    2. Checking if it exists and failing with a "nice" message, if it doesn't.
#    3. Waiting for it to exist.

# if ! nft list set ip filter osbuildapi >& /dev/null; then
#   exit 0
# fi

if ! nft list set ip filter osbuildapi >& /dev/null; then
  echo "OSBUILD: nft set ip filter osbuildapi: Doesn't exist" 1>&2;
  exit 2
fi

while ! nft list set ip filter osbuildapi >& /dev/null; do
  sleep 10
done

# in staging we need to allow api.stage and in prod api.
{% if env == 'staging' %}
RESOLVEQUERY=`resolvectl -4 --cache=no --legend=no query api.stage.openshift.com 2> /dev/null`
{% else %}
RESOLVEQUERY=`resolvectl -4 --cache=no --legend=no query api.openshift.com 2> /dev/null`
{% endif %}
test $? -eq 0 || exit $?

NEWIPS=`echo "$RESOLVEQUERY" | grep link | sed -E 's/.* ([0-9]+\.[0-9]+\.[0-9]+\.[0-9]+).*/\1/g' | sort -n`


# both stage and prod authenticate using sso.redhat.com
RESOLVEQUERY=`resolvectl -4 --cache=no --legend=no query sso.redhat.com 2> /dev/null`
test $? -eq 0 || exit $?

NEWIDENTITYIPS=`echo "$RESOLVEQUERY" | grep link | sed -E 's/.* ([0-9]+\.[0-9]+\.[0-9]+\.[0-9]+).*/\1/g' | sort -n`

# Empty the filter: We do this at the end for a small window.`
# NOTE: We aren't flushing old entries anymore.
# See commit: e7b50aaee469fdded0ea650c7e7f4dd06e929609
# nft flush set ip filter osbuildapi

# Add the IPs...
for j in $NEWIPS
do
     nft add element ip filter osbuildapi { $j }
done

for j in $NEWIDENTITYIPS
do
     nft add element ip filter osbuildapi { $j }
done
