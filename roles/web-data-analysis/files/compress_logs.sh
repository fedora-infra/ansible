#!/bin/bash

LOGS_PATH='/mnt/fedora_stats/combined-http'

find $LOGS_PATH/20?? -type f -name -not -path $LOGS_PATH/`date +%Y`/`date +%m`/* "*.log" -exec xz -z {} \;
