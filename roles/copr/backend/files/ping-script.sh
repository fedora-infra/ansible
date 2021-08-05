#! /bin/sh

start_time=$(date +%s)
copr build-package @copr/copr-ping --name copr-ping
exit_status=$?
echo "start=$start_time stop=$(date +%s) exit_status=$exit_status" \
    >> ~/ping.log
