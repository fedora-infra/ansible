#!/bin/sh

URL="https://pdc.fedoraproject.org/rest_api/v1/releases/?active=True&name=Fedora"
CRAWLER="/usr/bin/mm2_crawler"
LOGBASE="/var/log/mirrormanager/propagation"


ACTIVE=`mktemp`

trap "rm -f ${ACTIVE}" QUIT TERM INT HUP EXIT

curl -s ${URL} >> ${ACTIVE}

if [ $? -ne 0 ]; then
	echo "PROPAGATION: Querying the active collections failed. Exiting!"
	exit 1
fi

# check propagation for the active branches
for version in `jq -r ".results[$i].version" < ${ACTIVE} | grep -v Rawhide`; do
	if [[ ${version} -lt 28 ]]; then
		${CRAWLER} --category "Fedora Linux" --propagation --proppath updates/${version}/x86_64/repodata --threads 50 2>&1 | grep SHA256 > ${LOGBASE}/f${version}_updates-propagation.log.$( date +%s )
	else
		${CRAWLER} --category "Fedora Linux" --propagation --proppath updates/${version}/Everything/x86_64/repodata --threads 50 2>&1 | grep SHA256 > ${LOGBASE}/f${version}_updates-propagation.log.$( date +%s )
	fi
done

# check propagation for the development branch
${CRAWLER} --category "Fedora Linux" --propagation --proppath development/rawhide/Everything/x86_64/os/repodata --threads 50 2>&1 | grep SHA256 > ${LOGBASE}/development-propagation.log.$( date +%s )

# check propagation for EPEL
for version in 7 8 9; do
	if [[ ${version} -lt 8 ]]; then
		${CRAWLER} --category "Fedora EPEL" --propagation --proppath ${version}/x86_64/repodata --threads 50 --timeout 1 2>&1 | grep SHA256 > ${LOGBASE}/epel${version}-propagation.log.$( date +%s )
	else
		${CRAWLER} --category "Fedora EPEL" --propagation --proppath ${version}/Everything/x86_64/repodata --threads 50 --timeout 1 2>&1 | grep SHA256 > ${LOGBASE}/epel${version}-propagation.log.$( date +%s )
	fi
done

# check propagation for CentOS
${CRAWLER} --category "CentOS" --propagation --proppath 9-stream/BaseOS/x86_64/os/repodata --threads 50 --timeout 1 2>&1 | grep SHA256 > ${LOGBASE}/centos9-propagation.log.$( date +%s )

# clean up log files older than 14 days
/usr/sbin/tmpwatch --mtime 14d ${LOGBASE}
