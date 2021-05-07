#!/usr/bin/env python3

import os
import socket
from datetime import datetime, timedelta

from python_freeipa import ClientMeta

KEEP_DAYS = 7
KEYTAB = "/etc/krb5.stage-users_{hostname}.keytab"

hostname = socket.gethostname()
os.environ["KRB5_CLIENT_KTNAME"] = KEYTAB.format(hostname=hostname)
client = ClientMeta(hostname)
client.login_kerberos()
threshold = datetime.utcnow() - timedelta(days=KEEP_DAYS)
for user in client.stageuser_find()["result"]:
    username = user["uid"][0]
    created_on = datetime.strptime(
        user["fascreationtime"][0]["__datetime__"], "%Y%m%d%H%M%SZ"
    )
    if created_on > threshold:
        continue
    print(f"Deleting old stage user: {username}")
    client.stageuser_del(username)
