#!/bin/sh

BASE_SRC_DIR=/srv/private/ansible/files/rabbitmq
BASE_DEST_DIR=/srv/web/infra/rabbitmq-certs
EXPIRATION_FILE=expiration.txt

set -e

for env in staging production; do
    dest_dir=${BASE_DEST_DIR}/${env}
    mkdir -p ${dest_dir}
    > ${dest_dir}/${EXPIRATION_FILE}
    for cert in `ls ${BASE_SRC_DIR}/${env}/pki/issued/*.crt`; do
        cp -a $cert ${dest_dir}/
        chmod 644 ${dest_dir}/*.crt
        name=`basename $cert .crt`
        exp_date=`openssl x509 -enddate -noout -dateopt iso_8601 -in $cert | cut -d= -f2`
        echo -e "$name\t$exp_date" >> ${dest_dir}/${EXPIRATION_FILE}
    done
done
