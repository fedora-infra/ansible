#!/bin/bash

# this is a hideous hack to find and kill qemu processes stuck as a
# result of https://github.com/os-autoinst/os-autoinst/issues/2549
# which cause workers to be stuck in broken state. affected workers
# should recover some minutes after this script runs
for i in {1..35}; do journalctl -u openqa-worker-plain@$i.service -n 5 | grep "is still running" | grep -o "PID: [0-9]\+" | cut -d" " -f2 | sort -u | xargs kill 2> /dev/null; done
