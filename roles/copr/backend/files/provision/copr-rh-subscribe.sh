#! /bin/bash

die()
{
    echo >&2 "ERROR: $*" && exit 1
}

show_help()
{
cat <<EOHELP >&2
Usage: $0 --pool-id POOL_ID --user USER --pass PASS --system NAME
EOHELP

test -z "$1" || exit "$1"
}

# handle no arguments
test ${#@} -eq 0 && show_help 1

ARGS=$(getopt -o "h" -l "pool-id:,user:,pass:,system:,help" -n "getopt" -- "$@") \
    || show_help 1
eval set -- "$ARGS"

option_variable()
{
    # Function to convert '--some-option' to '$opt_some_option".
    opt=$1
    opt=${1##--}
    opt=${opt##-}
    opt=${opt//-/_}
    option_variable_result=opt_$opt
}

opt_system=
opt_user=
opt_pass=
opt_pool_id=

while true; do
    case $1 in
    -h|--help)
        show_help 0
        ;;

    --pool-id|--user|--pass|--system)
        option_variable "$1"
        eval "$option_variable_result=\$2"
        shift 2
        ;;

    --) shift; break;;  # end
    *) echo "programmer mistake ($1)" >&2; exit 1;;
    esac
done

set -x
provided=true

for i in system user pass pool_id; do
    varname=opt_$i
    if eval 'test -z "$'"$varname"'"'; then
        provided=false
        echo >&2 "$varname required"
    fi
done
$provided || die "some options missing"

try_indefinitely()
{
    cmd=( "$@" )
    while :; do
        if "${cmd[@]}"; then
            break
        fi
        sleep 5
    done
}

try_indefinitely subscription-manager register --force \
        --username "$opt_user" \
        --password "$opt_pass" \
        --name "$opt_system"

try_indefinitely subscription-manager attach --pool "$opt_pool_id"
