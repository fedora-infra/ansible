#!/bin/bash

# Don't attempt to combine if syncing the individual logs failed.
set -e

/usr/local/bin/sync-http-logs.py
/usr/local/bin/combineHttpLogs.sh
