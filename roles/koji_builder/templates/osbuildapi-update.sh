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

{% if env == 'staging' %}
# in stg we need to add identity.api because we are using api.stage above. 
# in prod this is already the same as api.openshift.com, so skip it.
RESOLVEQUERY=`resolvectl --cache=no --legend=no query identity.api.openshift.com 2> /dev/null`
test $? -eq 0 || exit $?

NEWIDENTITYIPS=`echo $RESOLVEQUERY | grep link | awk '{print $2 " " $6}' | sort -n`

for j in $NEWIDENTITYIPS
do
     /usr/sbin/ipset add osbuildapi $j
done
{% endif %}
