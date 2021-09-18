#!/bin/bash

if [ ! -d  /srv/web/kinoite.fedoraproject.org/.git ]
then
    /usr/bin/git clone -q https://pagure.io/fedora-kde/kinoite-site /srv/web/kinoite.fedoraproject.org
fi

cd /srv/web/kinoite.fedoraproject.org

/usr/bin/git clean -q -fdx || exit 1
/usr/bin/git fetch -q || exit 1
/usr/bin/git reset -q --hard origin/staging || exit 1
