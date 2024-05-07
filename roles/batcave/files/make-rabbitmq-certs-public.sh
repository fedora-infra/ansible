#!/bin/sh

BASE_SRC_DIR=/srv/private/ansible/files/rabbitmq
BASE_DEST_DIR=/var/cache/rabbitmq-certs

set -e

for env in staging production; do
        dest_dir=${BASE_DEST_DIR}/${env}
        mkdir -p ${dest_dir}
        cp -a ${BASE_SRC_DIR}/${env}/pki/issued/*.crt ${dest_dir}/
        chmod 644 ${dest_dir}/*.crt
done
