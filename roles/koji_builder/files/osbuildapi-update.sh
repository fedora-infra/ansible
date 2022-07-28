#!/bin/bash

/usr/sbin/ipset create osbuildapi hash:ip >& /dev/null

RESOLVEQUERY=`resolvectl --cache=no --legend=no query api.stage.openshift.com 2> /dev/null`         
test $? -eq 0 || exit $?

NEWIPS=`echo $RESOLVEQUERY | grep link | awk '{print $2 " " $6}' | sort -n`                         
#APIIP=`resolvectl --cache=no --legend=no query api.stage.openshift.com | grep link | sed -e "s|api.stage.openshift.com:||" | awk '{print $1}'`

/usr/sbin/ipset flush osbuildapi
for j in $NEWIPS
do
     /usr/sbin/ipset add osbuildapi $j
done
