#!/bin/bash

pip install alembic
alembic -c /etc/alembic-upgrade-script/alembic.ini upgrade head
