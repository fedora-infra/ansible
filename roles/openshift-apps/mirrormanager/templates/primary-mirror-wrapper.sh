#!/bin/bash

# This script checks for changes on the primary mirror and
# updates the database if changes are found. For most categories
# the script first checks if a fullfiletimelist-<category>
# exists and runs the actual primary mirror scan if that file
# has changed.
# It is derived from umdl-required

if [ $# -ne 1 ]; then
	echo "Exactly one parameter needed: category"
	exit 1
fi

BINDIR="/opt/app-root/bin"
SPOOLDIR="/var/lib/mirrormanager/spool"

CURDATE=`date +%s`
SCANNER="${BINDIR}/mm2_update-master-directory-list"

if [ "${1}" ==  "fedora" ]; then
	CATEGORY="Fedora Linux"
elif [ "${1}" ==  "epel" ]; then
	CATEGORY="Fedora EPEL"
	SCANNER="${BINDIR}/scan-primary-mirror"
elif [ "${1}" ==  "alt" ]; then
	CATEGORY="Fedora Other"
elif [ "${1}" ==  "fedora-secondary" ]; then
	CATEGORY="Fedora Secondary Arches"
	SCANNER="${BINDIR}/scan-primary-mirror -d"
elif [ "${1}" ==  "archive" ]; then
	CATEGORY="Fedora Archive"
	SCANNER="${BINDIR}/scan-primary-mirror -d"
elif [ "${1}" ==  "codecs" ]; then
	CATEGORY="Fedora Codecs"
	SCANNER="${BINDIR}/scan-primary-mirror"
elif [ "${1}" ==  "eln" ]; then
	CATEGORY="Fedora ELN"
	SCANNER="${BINDIR}/scan-primary-mirror"
elif [ "${1}" ==  "centos" ]; then
	CATEGORY="CentOS"
	SCANNER="${BINDIR}/scan-primary-mirror -c /etc/mirrormanager/scan-primary-mirror-centos.toml -d"
fi

if [ -e ${SPOOLDIR}/umdl-${1} ]; then
	. ${SPOOLDIR}/umdl-${1}
else
	mkdir -p "${SPOOLDIR}"
	# 24 hours -> 86400 seconds
	let LASTRUN=CURDATE-86400
fi

if [ "${1}" ==  "centos" ]; then
	CENTOS_PRIMARY="mref1-priv.iad2.centos.org"
	# check if a sync is currently in process
	CODE=$( curl -s -o /dev/null -I -w "%{http_code}" http://${CENTOS_PRIMARY}/9-stream/.sync_in_progress )
	if [ "${CODE}" -eq "200" ]; then
		echo -n "CentOS primary mirror sync in progress. Skipping scan at "
		date
		exit 0
	fi
	if [ "${CODE}" -eq "000" ]; then
		echo -n "CentOS primary mirror is unreachable. Skipping scan at "
		date
		exit 1
	fi
	FFTL="http://${CENTOS_PRIMARY}/9-stream/COMPOSE_ID"
	FILEDATE=`date +%s -d"$( curl -s --head ${FFTL} | awk 'BEGIN {FS=": "}/^Last-Modified/{print $2}' )"`
	FFTL_SIGS="http://${CENTOS_PRIMARY}/SIGs/9-stream/COMPOSE_ID"
	FILEDATE_SIGS=`date +%s -d"$( curl -s --head ${FFTL_SIGS} | awk 'BEGIN {FS=": "}/^Last-Modified/{print $2}' )"`
	if [ "$FILEDATE_SIGS" -gt "$FILEDATE" ]; then
		FILEDATE=$FILEDATE_SIGS
		FFTL=$FFTL_SIGS
	fi
elif [ "${1}" ==  "codecs" ]; then
	FFTL="${CATEGORY}"
	FILEDATE=${CURDATE}
else
	FFTL="/srv/pub/${1}/fullfiletimelist-${1}"
	FILEDATE=`stat -c %Z ${FFTL} 2> /dev/null`

	if [ "$?" -eq "1" ]; then
		echo "Error stat() of ${FFTL} failed. This should not happen."
		exit 1
	fi
fi

# Rerun scan after 24 hours
if [ "$LASTRUN" -gt "$FILEDATE" ] && [ "$LASTRUN" -gt $(expr $CURDATE - 86400) ]; then
	echo "No changes on the master mirror (${FFTL})"
	# abort
	exit 0
fi

echo -n "${FFTL} has changed since last run. Running umdl for ${CATEGORY} at "
date

${SCANNER} --category "${CATEGORY}"

if [ "$?" -eq "0" ]; then
	# success! remember the date of this run
	echo "LASTRUN=${CURDATE}" > ${SPOOLDIR}/umdl-${1}
	echo -n "Finished umdl for ${CATEGORY} successfully at "
	date
	exit 0
fi

echo -n "umdl for ${CATEGORY} returned non-zero. Something failed."
date
exit 1
