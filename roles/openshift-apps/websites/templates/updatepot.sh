#!/bin/bash

# Add OCP user to passwd
USER_ID=$(id -u)
grep -Ev ":x:${USER_ID}:" /etc/passwd > /tmp/passwd
echo "ocpuser:x:${USER_ID}:0:ocp user:/:/sbin/nologin" >> /tmp/passwd
export LD_PRELOAD=/usr/lib64/libnss_wrapper.so
export NSS_WRAPPER_PASSWD=/tmp/passwd
export NSS_WRAPPER_GROUP=/etc/group


cd /tmp
git clone https://pagure.io/fedora-web/websites.git
cd websites

for i in getfedora.org; do
  pushd sites/$i/scripts
  ./translations-source.sh
  [ -f $i.pot ] && ./push-pot.sh
  popd
done
