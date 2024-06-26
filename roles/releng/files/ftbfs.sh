#!/bin/bash
# A weekly cron job which actually does the items needed.
# Only run every third week, see https://pagure.io/releng/issue/8915

touch /tmp/fedora-compose-cronjob-ftbts.cron

test $(($(date +%W | sed s.^0..) % 3)) -eq 0 || exit 0
TMPDIR=`mktemp -d /tmp/ftbfs_reminder.XXXXXX`
GITREPO=https://pagure.io/releng.git
SCRIPT=ftbfs_weekly_reminder.py
if [ $? -eq 0 ]; then
    cd ${TMPDIR}
    git clone ${GITREPO}
    if [ $? -eq 0 ]; then
	cd releng/scripts
	./${SCRIPT}
	if [ $? -ne 0 ]; then
	    echo "${SCRIPT} had an error condition"
	    echo "Look in ${TMPDIR} for more info"
	    # Do not clean up trash
	    rm /tmp/fedora-compose-cronjob-ftbts.cron
	    exit 1
	fi
    else
	echo "Unable to clone ${GITREPO}"
	echo "Look in ${TMPDIR} for more info"
	# Do not clean up trash
	rm /tmp/fedora-compose-cronjob-ftbts.cron
	exit 1
    fi
    cd /tmp/
    rm -rf $TMPDIR
    rm /tmp/fedora-compose-cronjob-ftbts.cron
else
    echo "Unable to create ${TMPDIR}"
    rm /tmp/fedora-compose-cronjob-ftbts.cron
    exit 1
fi

#FTBFS Weekly Reminder

