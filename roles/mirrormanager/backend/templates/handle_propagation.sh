#!/bin/sh

URL="https://pdc.fedoraproject.org/rest_api/v1/releases/?active=True&name=Fedora"
PROPAGATION="/usr/bin/mm2_propagation"
SOURCE="mm-crawler01.iad2.fedoraproject.org::propagation"
LOGBASE="/var/log/mirrormanager/propagation"

FRONTENDS="{% for host in groups['mm_frontend'] %} {{ host }} {% endfor %}"

OUTPUT=`mktemp -d`
ACTIVE=`mktemp`

trap "rm -f ${OUTPUT}/*; rmdir ${OUTPUT}; rm -f ${ACTIVE}" QUIT TERM INT HUP EXIT

rsync -aq --delete ${SOURCE} ${LOGBASE}

curl -s ${URL} >> ${ACTIVE}

if [ $? -ne 0 ]; then
        echo "PROPAGATION: Querying the active collections failed. Exiting!"
        exit 1
fi

for version in `jq -r ".results[$i].version" < ${ACTIVE} | grep -v Rawhide`; do
        ${PROPAGATION} --outdir ${OUTPUT} --logfiles "${LOGBASE}/f${version}*" --prefix f${version}_updates
done

${PROPAGATION} --outdir ${OUTPUT} --logfiles "${LOGBASE}/development*"

# EPEL
for version in 7 8 9; do
        ${PROPAGATION} --outdir ${OUTPUT} --logfiles "${LOGBASE}/epel${version}*" --prefix epel${version}
done

# CentOS
for version in 9; do
        ${PROPAGATION} --outdir ${OUTPUT} --logfiles "${LOGBASE}/centos${version}*" --prefix centos${version}
done

for f in ${FRONTENDS}; do
        rsync -aq   ${OUTPUT}/*[st]-repomd-propagation.svg  ${f}:/var/www/mirrormanager-statistics/data/propagation
        rsync -aq   ${OUTPUT}/epel[789]-repomd-propagation.svg  ${f}:/var/www/mirrormanager-statistics/data/propagation
	rsync -aq   ${OUTPUT}/centos[9]-repomd-propagation.svg  ${f}:/var/www/mirrormanager-statistics/data/propagation
done
