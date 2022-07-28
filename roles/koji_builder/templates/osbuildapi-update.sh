#!/bin/bash

# Make sure the ipset is created.
/usr/sbin/ipset create osbuildapi hash:ip >& /dev/null

# in staging we need to allow api.stage and in prod api.
{% if env == 'staging' %}
RESOLVEQUERY=`resolvectl --cache=no --legend=no query api.stage.openshift.com 2> /dev/null`
{% else %}
RESOLVEQUERY=`resolvectl --cache=no --legend=no query api.openshift.com 2> /dev/null`
{% endif %}
test $? -eq 0 || exit $?

NEWIPS=`echo $RESOLVEQUERY | grep link | awk '{print $2 " " $6}' | sort -n`

/usr/sbin/ipset flush osbuildapi
for j in $NEWIPS
do
     /usr/sbin/ipset add osbuildapi $j
done

# in both stg and prod apparently we use idenity.adpi.openshift.com for auth
RESOLVEQUERY=`resolvectl --cache=no --legend=no query identity.api.openshift.com 2> /dev/null`
test $? -eq 0 || exit $?

NEWIDENTITYIPS=`echo $RESOLVEQUERY | grep link | awk '{print $2 " " $6}' | sort -n`

for j in $NEWIDENTITYIPS
do
     /usr/sbin/ipset add osbuildapi $j
done
