#!/bin/bash

LOGS_PATH='/mnt/fedora_stats/combined-http'

find $LOGS_PATH/20?? -type f -name '*.log' -not -path $LOGS_PATH/`date +%Y`/`date +%m`/* -exec pxz -z -T 5 {} \;
