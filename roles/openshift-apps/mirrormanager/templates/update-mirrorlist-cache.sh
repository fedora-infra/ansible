#!/bin/bash

MIRRORLIST_PROXY="{% for host in groups['mirrorlist_proxies'] %} {{ host }} {% endfor %}"
MM_USER=mirrormanager
MM_ROOT=/opt/app-root
MM_SSH_KEY=/etc/mirrormanager-ssh/ssh_mirrorlist_proxies.key
CACHEDIR=/data

set -e
set -x

rm -rf ${CACHEDIR}/old
mkdir -p ${CACHEDIR}/old
chmod g+w ${CACHEDIR}/old
if ls ${CACHEDIR}/*.* &>/dev/null; then
	cp -arf ${CACHEDIR}/*.*  ${CACHEDIR}/old/
fi

${MM_ROOT}/bin/generate-mirrorlist-cache -o ${CACHEDIR}/mirrorlist_cache.proto

# Update the files on the proxies
{% if env == 'production' %}
for server in ${MIRRORLIST_PROXY}; do
	# *.txt files are netblocks
	rsync -az --delete-delay --delay-updates --delete \
		-e "ssh -i ${MM_SSH_KEY} -o BatchMode=yes -o StrictHostKeyChecking=no" \
		${MM_ROOT}/src/utility/country_continent.csv \
		${CACHEDIR}/mirrorlist_cache.proto \
		${CACHEDIR}/*.txt \
		${MM_USER}@${server}:/srv/mirrorlist/data/mirrorlist1/ &
done
# Wait for the background jobs
wait $(jobs -p)
{% endif %}
