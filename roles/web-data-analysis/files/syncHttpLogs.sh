#!/bin/bash

RSYNC_FLAGS='-avSHP --no-motd --timeout=1200 --contimeout=1200'
DEBUG=1

RUN_ID="$(uuidgen -r)"
LOGHOST="$(hostname)"
MSGTOPIC_PREFIX="logging.stats"

function send_bus_msg {
    local topic="${MSGTOPIC_PREFIX}.$1"
    shift
    local sent_at="$(TZ=UTC date -Iseconds)"
    local id="$(uuidgen -r)"
    local body_piece
    local body="{"
    local sep=""

    for body_piece; do
        local key_type key type value
        key_type="${body_piece%%=*}"
        key="${key_type%%:*}"
        type="${key_type#${key}}"
        type="${type#:}"
        value="${body_piece#*=}"

        if [ "$type" != "int" ]; then
            # quote strings
            value="${value//\\/\\\\}"
            value="${value//\"/\\\"}"
            value="\"${value}\""
        fi
        body="${body}${sep}\"${key}\": ${value}"
        sep=", "
    done
    body="${body}}"

    fedora-messaging publish - << EOF >/dev/null
{"body": ${body}, "headers": {"fedora_messaging_schema": "base.message", "fedora_messaging_severity": 20, "sent-at": "${sent_at}"}, "id": "${id}", "queue": "queue", "topic": "${topic}"}
EOF
}

function syncHttpLogs {
    HOST=$1
    send_bus_msg sync.host.start host="$LOGHOST" run_id="$RUN_ID" synced_host="$HOST"
    # in case we missed a run or two.. try to catch up the last 3 days.
    for d in 1 2 3; do
    # some machines store stuff in old format. some new.
        if [ "$2" = "old" ]; then
            YESTERDAY=$(/bin/date -d "-$d days" +%Y-%m-%d)
        else
            YESTERDAY=$(/bin/date -d "-$d days" +%Y%m%d)
        fi
        YEAR=$(/bin/date -d "-$d days" +%Y)
        MONTH=$(/bin/date -d "-$d days" +%m)
        DAY=$(/bin/date -d "-$d days" +%d)
        send_bus_msg sync.host.logdate.start host="$LOGHOST" run_id="$RUN_ID" synced_host="$HOST" log_date="${YEAR}-${MONTH}-${DAY}"
        /bin/mkdir -p /var/log/hosts/$HOST/$YEAR/$MONTH/$DAY/http
        cd /var/log/hosts/$HOST/$YEAR/$MONTH/$DAY/http/
        RSYNC_OUTPUT=$(/usr/bin/rsync $RSYNC_FLAGS --list-only $HOST::log/httpd/*$YESTERDAY* | grep xz$ | awk '{ print $5 }' )
        for f in ${RSYNC_OUTPUT}; do
            DEST=$(echo $f | /bin/sed s/-$YESTERDAY//)
            if [[ ${DEBUG} -eq 1 ]]; then
                echo "${HOST}: Getting ${f} and saving to ${DEST}"
            fi
            for i in 2 1 0; do
                timeout 2h /usr/bin/rsync $RSYNC_FLAGS $HOST::log/httpd/$f ./$DEST &> /dev/null && break
                if [[ $? -ne 0 ]]; then
                    send_bus_msg sync.host.logdate.fail.retry host="$LOGHOST" run_id="$RUN_ID" synced_host="$HOST" log_date="${YEAR}-${MONTH}-${DAY}" failure="Error code: $?"
                    echo "rsync from $HOST for file $f failed, will repeat $i times"
                else
                    send_bus_msg sync.host.logdate.fail.final host="$LOGHOST" run_id="$RUN_ID" synced_host="$HOST" log_date="${YEAR}-${MONTH}-${DAY}" failure="Error code: $?"
                fi
            done
        done
        send_bus_msg sync.host.logdate.finish host="$LOGHOST" run_id="$RUN_ID" synced_host="$HOST" log_date="${YEAR}-${MONTH}-${DAY}"
    done
    send_bus_msg sync.host.finish host="$LOGHOST" run_id="$RUN_ID" synced_host="$HOST"
}

send_bus_msg sync.start host="$LOGHOST" run_id="$RUN_ID"

syncHttpLogs proxy01.iad2.fedoraproject.org
syncHttpLogs proxy02.vpn.fedoraproject.org
syncHttpLogs proxy03.vpn.fedoraproject.org
syncHttpLogs proxy04.vpn.fedoraproject.org
syncHttpLogs proxy05.vpn.fedoraproject.org
syncHttpLogs proxy06.vpn.fedoraproject.org
# syncHttpLogs proxy08.vpn.fedoraproject.org
syncHttpLogs proxy09.vpn.fedoraproject.org # proxy09 is acting up
syncHttpLogs proxy10.iad2.fedoraproject.org
syncHttpLogs proxy11.vpn.fedoraproject.org
syncHttpLogs proxy12.vpn.fedoraproject.org
syncHttpLogs proxy13.vpn.fedoraproject.org
syncHttpLogs proxy14.vpn.fedoraproject.org
syncHttpLogs proxy30.vpn.fedoraproject.org
syncHttpLogs proxy31.vpn.fedoraproject.org
syncHttpLogs proxy32.vpn.fedoraproject.org
syncHttpLogs proxy33.vpn.fedoraproject.org
syncHttpLogs proxy34.vpn.fedoraproject.org
syncHttpLogs proxy35.vpn.fedoraproject.org
syncHttpLogs proxy36.vpn.fedoraproject.org
syncHttpLogs proxy37.vpn.fedoraproject.org
syncHttpLogs proxy38.vpn.fedoraproject.org
syncHttpLogs proxy39.vpn.fedoraproject.org
syncHttpLogs proxy40.vpn.fedoraproject.org
syncHttpLogs proxy101.iad2.fedoraproject.org
syncHttpLogs proxy110.iad2.fedoraproject.org
# syncHttpLogs proxy01.stg.iad2.fedoraproject.org
syncHttpLogs datagrepper01.iad2.fedoraproject.org
# syncHttpLogs datagrepper02.iad2.fedoraproject.org
# syncHttpLogs datagrepper01.stg.iad2.fedoraproject.org
# syncHttpLogs badges-web01.iad2.fedoraproject.org
# syncHttpLogs badges-web02.iad2.fedoraproject.org
# syncHttpLogs badges-web01.stg.iad2.fedoraproject.org
# syncHttpLogs packages03.iad2.fedoraproject.org
# syncHttpLogs packages04.iad2.fedoraproject.org
# syncHttpLogs packages03.stg.iad2.fedoraproject.org
syncHttpLogs blockerbugs01.iad2.fedoraproject.org
# syncHttpLogs blockerbugs02.iad2.fedoraproject.org
# syncHttpLogs blockerbugs01.stg.iad2.fedoraproject.org
syncHttpLogs value01.iad2.fedoraproject.org
syncHttpLogs people02.vpn.fedoraproject.org
syncHttpLogs noc01.iad2.fedoraproject.org
syncHttpLogs dl01.iad2.fedoraproject.org
syncHttpLogs dl02.iad2.fedoraproject.org
syncHttpLogs dl03.iad2.fedoraproject.org
syncHttpLogs dl04.iad2.fedoraproject.org
syncHttpLogs dl05.iad2.fedoraproject.org
syncHttpLogs download-rdu01.vpn.fedoraproject.org
syncHttpLogs download-ib01.vpn.fedoraproject.org
syncHttpLogs download-cc-rdu01.vpn.fedoraproject.org
syncHttpLogs sundries01.iad2.fedoraproject.org
# syncHttpLogs sundries02.iad2.fedoraproject.org
# syncHttpLogs sundries01.stg.iad2.fedoraproject.org

send_bus_msg sync.finish host="$LOGHOST" run_id="$RUN_ID"
## eof
