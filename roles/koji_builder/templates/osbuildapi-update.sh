#!/bin/bash

# Make sure the ipset is created.
/usr/sbin/ipset create osbuildapi hash:ip >& /dev/null

# in staging we need to allow api.stage and in prod api.
{% if env == 'staging' %}
RESOLVEQUERY=`resolvectl -4 --cache=no --legend=no query api.stage.openshift.com 2> /dev/null`
{% else %}
RESOLVEQUERY=`resolvectl -4 --cache=no --legend=no query api.openshift.com 2> /dev/null`
{% endif %}
test $? -eq 0 || exit $?

NEWIPS=`echo "$RESOLVEQUERY" | grep link | sed -E 's/.* ([0-9]+\.[0-9]+\.[0-9]+\.[0-9]+).*/\1/g' | sort -n`

for j in $NEWIPS
do
     /usr/sbin/ipset add osbuildapi $j
done

# both stage and prod authenticate using sso.redhat.com
RESOLVEQUERY=`resolvectl -4 --cache=no --legend=no query sso.redhat.com 2> /dev/null`
test $? -eq 0 || exit $?

NEWIDENTITYIPS=`echo "$RESOLVEQUERY" | grep link | sed -E 's/.* ([0-9]+\.[0-9]+\.[0-9]+\.[0-9]+).*/\1/g' | sort -n`

for j in $NEWIDENTITYIPS
do
     /usr/sbin/ipset add osbuildapi $j
done
