#!/bin/bash

set -e
set -x

DIR=/var/lib/badges

if [ ! -d "$DIR/.git" ]; then
	git clone https://pagure.io/fedora-badges.git $DIR
fi

git config --global --add safe.directory $DIR
git -C $DIR pull
