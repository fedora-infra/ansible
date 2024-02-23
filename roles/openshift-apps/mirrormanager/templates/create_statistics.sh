#!/bin/bash

MIRRORLIST_PROXIES="{% for host in groups['mirrorlist_proxies'] %} {{ host }} {% endfor %}"

MIRRORLIST_LOGDIR="/var/log/mirrormanager"
MIRRORLIST_LOGFILES="mirrorlist1.service.log mirrorlist2.service.log"
SSH_KEY="/etc/mirrormanager-ssh/ssh_mirrorlist_proxies.key"
REMOTE_USER="mirrormanager"

SSH="ssh -i ${SSH_KEY} -o StrictHostKeyChecking=no -o BatchMode=yes"
DATE=`date +%Y%m%d`
OUTPUT=`mktemp -d`

trap "rm -f ${OUTPUT}/*; rmdir ${OUTPUT}" QUIT TERM INT HUP EXIT

set -x

for proxy in ${MIRRORLIST_PROXIES}; do
	if [ "$1" == "yesterday" ]; then
		for logfile in ${MIRRORLIST_LOGFILES}; do
			${SSH} ${REMOTE_USER}@${proxy} "( xzcat ${MIRRORLIST_LOGDIR}/${logfile}-${DATE}.xz | grep -v 127.0.0.1 | gzip -4 )" >> ${OUTPUT}/mirrorlist.log.gz
		done
	fi
	for logfile in ${MIRRORLIST_LOGFILES}; do
		${SSH} ${REMOTE_USER}@${proxy} "( cat ${MIRRORLIST_LOGDIR}/${logfile} | grep -v 127.0.0.1 | gzip -4 )" >> ${OUTPUT}/mirrorlist.log.gz
	done
done

if [ "$1" == "yesterday" ]; then
	OPTIONS="-o 1"
else
	OPTIONS=""
fi

mm2_mirrorlist-statistics ${OPTIONS} -l ${OUTPUT}/mirrorlist.log.gz
