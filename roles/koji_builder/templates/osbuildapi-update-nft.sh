#!/bin/bash

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
# nft flush set global osbuildapi

# Add the IPs...
for j in $NEWIPS
do
     nft add element ip global osbuildapi { $j }
done

for j in $NEWIDENTITYIPS
do
     nft add element ip global osbuildapi { $j }
done
