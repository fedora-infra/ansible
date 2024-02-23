#!/bin/bash

MIRRORLIST_PROXY="{% for host in groups['mirrorlist_proxies'] %} {{ host }} {% endfor %}"
MM_ROOT=/opt/app-root
CACHEDIR=/data

set -e
set -x

rm -rf ${CACHEDIR}/old
mkdir -p ${CACHEDIR}/old
chmod g+w ${CACHEDIR}/old
cp -arf ${CACHEDIR}/*.*  ${CACHEDIR}/old/

${MM_ROOT}/bin/generate-mirrorlist-cache -o ${CACHEDIR}/mirrorlist_cache.proto

# Update the files on the proxies
{% if env == 'production' %}
for server in ${MIRRORLIST_PROXY}; do
	rsync -az --delete-delay --delay-updates --delete \
		${MM_ROOT}/mirrormanager2/crawler/country_continent.csv \
		${CACHEDIR}/mirrorlist_cache.proto \
		${CACHEDIR}/*.txt \  # Netblocks
		${server}:/srv/mirrorlist/data/mirrorlist1/ &
done
{% endif %}
