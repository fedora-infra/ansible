#!/bin/bash

# What are we called (used for message bus so don't just use cmd $0)
CMD_NAME=countme-centos-update

export MSGTOPIC_PREFIX=logging.stats
export MSGBODY_PRESET="loghost=$(hostname) run_id=$(uuidgen -r)"
simple_message_to_bus $CMD_NAME.start

# Where do we keep our local/internal data?
LOCAL_DATA_DIR=/var/lib/countme
RAW_DB=$LOCAL_DATA_DIR/raw-centos.db
TOTALS_DB=$LOCAL_DATA_DIR/totals-centos.db
TOTALS_CSV=$LOCAL_DATA_DIR/totals-centos.csv
LOGFMT="%Y/%m/%d/mirrors.centos.org-access.log"

# Where do we put the public-facing data?
PUBLIC_DATA_DIR=/var/www/html/csv-reports/countme
PUBLIC_TOTALS_DB=$PUBLIC_DATA_DIR/totals-centos.db
PUBLIC_TOTALS_CSV=$PUBLIC_DATA_DIR/totals-centos.csv

# Names of the update commands.
# From python3*-mirrors-countme Eg. python3.11-mirrors-countme-0.1.2-1.el8
# They should be in PATH somewhere...
UPDATE_RAWDB=countme-update-rawdb.sh
UPDATE_TOTALS=countme-update-totals.sh
UPDATE_TRIM=countme-trim-raw
# Names of the post update commands. They should be in PATH somewhere...
PUSH_SPLIT=countme-split-totals-db.sh
PUSH_REZIP=countme-rezip

# ------------------------------ NOTE ------------------------------
# Everything below this line should try to be identical between the
# fedora/centos scripts, to make any changes easier. Add more options
# above and then have the code below be the same.
# ------------------------------ NOTE ------------------------------

# How we're gonna call git - our local repo dir is LOCAL_DATA_DIR
_GIT="git -C $LOCAL_DATA_DIR"

# Copy with atomic overwrite
atomic_copy() {
    local src="$1" dst="$2"
    cp -f ${src} ${dst}.part
    mv -f ${dst}.part ${dst}
}

# die [MESSAGE]: prints "$PROG: error: $MESSAGE" on stderr and exits
die() { echo "${0##*/}: error: $*" >&2; exit 2; }

# _run [COMMAND...]: Run a command, honoring $VERBOSE and $DRYRUN
_run() {
    if [ "$VERBOSE" -o "$DRYRUN" ]; then echo "$@"; fi
    if [ "$DRYRUN" ]; then 
      return 0
    else
      simple_message_to_bus $CMD_NAME.command.start command="$@"
      "$@"
      RESULT=$?
      simple_message_to_bus $CMD_NAME.command.finish command="$@" result="$?"
      return $RESULT
    fi
}

# CLI help text
HELP_USAGE="usage: $CMD_NAME.sh [OPTION]..."
HELP_OPTIONS="
Options:
  -h, --help           Show this message and exit
  -v, --verbose        Show more info about what's happening
  -n, --dryrun         Don't run anything, just show commands
  -p, --progress       Show progress meters while running
"

# Turn on progress by default if stderr is a tty
if [ -z "$PROGRESS" -a -t 2 ]; then PROGRESS=1; fi

# Parse CLI options with getopt(1)
_GETOPT_TMP=$(getopt \
    --name $CMD_NAME \
    --options hvnp \
    --longoptions help,verbose,dryrun,progress,checkoutdir: \
    -- "$@")
eval set -- "$_GETOPT_TMP"
unset _GETOPT_TMP
while [ $# -gt 0 ]; do
    arg=$1; shift
    case $arg in
        '-h'|'--help') echo "$HELP_USAGE"; echo "$HELP_OPTIONS"; exit 0 ;;
        '-v'|'--verbose') VERBOSE=1 ;;
        '-n'|'--dryrun') DRYRUN=1 ;;
        '-p'|'--progress') PROGRESS=1 ;;
        # Hidden option for testing / manual use
        '--checkoutdir') COUNTME_CHECKOUT=$1; shift ;;
        '--') break ;;
    esac
done

# Tweak path if needed
if [ -d "$COUNTME_CHECKOUT" ]; then
    cd $COUNTME_CHECKOUT
    PATH="$COUNTME_CHECKOUT:$COUNTME_CHECKOUT/scripts:$PATH"
fi

# Hardcoding /usr/local/bin here is hacky; should be pulled from pip, but
# parsing pip output is nontrivial, and my father always told me:
# "Son, life's too damn short write a RFC2822 parser in bash."
PATH="$PATH:/usr/local/bin"

# Check for required commands
command -v $UPDATE_RAWDB  >/dev/null || die "can't find '$UPDATE_RAWDB'"
command -v $UPDATE_TOTALS >/dev/null || die "can't find '$UPDATE_TOTALS'"
command -v git            >/dev/null || die "can't find 'git'"
command -v $UPDATE_TRIM   >/dev/null || die "can't find '$UPDATE_TRIM'"

# Apply other CLI options
if [ "$PROGRESS" ]; then
    UPDATE_RAWDB="$UPDATE_RAWDB --progress"
    UPDATE_TOTALS="$UPDATE_TOTALS --progress"
fi

# Exit immediately on errors
set -e

# Run the updates
_run $UPDATE_RAWDB --rawdb $RAW_DB --logfmt $LOGFMT
_run $UPDATE_TOTALS --rawdb $RAW_DB --totals-db $TOTALS_DB --totals-csv $TOTALS_CSV

_run $UPDATE_TRIM --rw $RAW_DB 2

# If needed: init local git repo and mark file(s) to be tracked therein
if [ ! -d $LOCAL_DATA_DIR/.git ]; then
    _run $_GIT init
    _run $_GIT add -N $(realpath $TOTALS_CSV --relative-to $LOCAL_DATA_DIR)
fi
# If any tracked files were updated, commit changes
_run $_GIT diff --quiet || _run $_GIT commit -a -m "$(date -u +%F) update"

# Copy new data into place
_run atomic_copy $TOTALS_DB $PUBLIC_TOTALS_DB
_run atomic_copy $TOTALS_CSV $PUBLIC_TOTALS_CSV

command -v $PUSH_SPLIT   >/dev/null || die "can't find '$PUSH_SPLIT'"
command -v $PUSH_REZIP   >/dev/null || die "can't find '$PUSH_REZIP'"

_run $PUSH_SPLIT $PUBLIC_TOTALS_DB
_run $PUSH_REZIP $PUBLIC_DATA_DIR/*.db

simple_message_to_bus $CMD_NAME.finish

