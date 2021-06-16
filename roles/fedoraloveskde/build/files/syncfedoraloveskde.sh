#!/bin/bash

if [ ! -d  /srv/web/fedoraloveskde.org/.git ]
then
    /usr/bin/git clone -q https://pagure.io/fedora-kde/fedoraloveskde.org /srv/web/fedoraloveskde.org
fi

cd /srv/web/fedoraloveskde.org

/usr/bin/git clean -q -fdx || exit 1
/usr/bin/git reset -q --hard || exit 1
/usr/bin/git checkout -q production || exit 1
/usr/bin/git pull -q --ff-only || exit 1
