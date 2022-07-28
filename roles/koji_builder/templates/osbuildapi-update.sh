#!/bin/bash

/usr/sbin/ipset create osbuildapi hash:ip >& /dev/null

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
