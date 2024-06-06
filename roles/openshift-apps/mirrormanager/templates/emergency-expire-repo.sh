#!/bin/bash

MM_ROOT=/opt/app-root

set -e

${MM_ROOT}/bin/mm2_emergency-expire-repo $@
bash /opt/scripts/update-mirrorlist-cache.sh
