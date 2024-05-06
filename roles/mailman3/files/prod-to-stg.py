#!/usr/bin/env python
import os
import sys
import psycopg2

from configparser import ConfigParser
from subprocess import call

# Read the database information from mailman config
sys.path.insert(0, '/etc/mailman3')
if not os.getenv("DJANGO_SETTINGS_MODULE"):
    os.environ["DJANGO_SETTINGS_MODULE"] = "settings"

import django
django.setup()


MAILMAN_TABLES_TO_REPLACE = [
    ("domain", "mail_host"),
    ("mailinglist", "mail_host"),
    ("mailinglist", "list_id"),
    ("template", "context"),
    ("acceptablealias", "alias"),
]
DJANGO_TABLES_TO_EMPTY = [
    "account_emailconfirmation",
    "openid_openidnonce",
    "openid_openidstore",
    "socialaccount_socialtoken",
]


def update_col_1(connection, table, column, where=None, pk="id"):
    cursor = connection.cursor()
    cursor_2 = connection.cursor()
    query_where = " WHERE {}".format(where) if where is not None else ""
    #query = "SELECT COUNT(*) FROM {t} {w}".format(t=table, w=where)
    #cursor.execute(query)
    #count = cursor.fetchone()[0]
    query = "SELECT {pk}, {c} FROM {t} {w}".format(
        t=table, c=column, pk=pk, w=query_where)
    #query += " LIMIT 10000"
    print(query)
    #print("{} lines".format(count))
    updates = []
    cursor.execute(query)
    print(cursor.query)
    for record_id, value in cursor:
        changed_value = value.replace(
            "lists.fedoraproject.org", "lists.stg.fedoraproject.org"
            ).replace(
            "lists.fedorahosted.org", "lists.stg.fedorahosted.org"
            ).replace(
            "lists.pagure.io", "lists.stg.pagure.io")
        if value == changed_value:
            continue
        if column == pk:
            # Resilience: if the process is halted, there may be old and new
            # values in the same table.
            cursor_2.execute(
                "SELECT 1 FROM {t} WHERE {pk} = %s".format(t=table, pk=pk),
                [changed_value])
            if cursor_2.fetchone():
                print("Skipping {v} in {t}".format(t=table, v=changed_value))
                continue
        updates.append([changed_value, record_id])
    cursor_2.close()
    print("Doing {} updates now".format(len(updates)))
    query = "UPDATE {t} SET {c} = %s WHERE {pk} = %s".format(
        t=table, c=column, pk=pk)
    print(query, "with %d params" % len(updates))
    cursor.executemany(query, updates)


def do_mailman():
    config = ConfigParser()
    config.read("/etc/mailman.cfg")
    conn = psycopg2.connect(config.get("database", "url"))

    with conn.cursor() as cursor:
        for table, column in MAILMAN_TABLES_TO_REPLACE:
            update_col_1(conn, table, column)
        update_col_1(conn, "ban", "list_id",
                     where="list_id !~ 'lists.stg'")
        update_col_1(conn, "member", "list_id",
                     where="list_id !~ 'lists.stg'")
        update_col_1(conn, "bounceevent", "list_id",
                     where="list_id !~ 'lists.stg'")
        update_col_1(conn, "pendedkeyvalue", "value",
                     """ "key" = 'list_id' OR "key" = '_mod_listid' """
                     """ OR "key" = 'envsender'""")

        cursor.execute("UPDATE \"user\" SET password = 'INVALID'")
        print(cursor.query)
        cursor.execute("UPDATE \"mailinglist\" SET digests_enabled = FALSE")
        print(cursor.query)
    conn.commit()
    conn.close()
    call(["sudo", "-u", "mailman", "mailman3", "aliases"])


def do_django():
    from django.db import connection, transaction
    with connection.cursor() as cursor:
        cursor.execute("UPDATE auth_user SET password = '!INVALID'")
        print(cursor.query)
        # Empty tables that contain sensitive data
        for table in DJANGO_TABLES_TO_EMPTY:
            cursor.execute("DELETE FROM %s" % table)
            print(cursor.query)
        with transaction.atomic():
            # Replace in tables with prod domains:
            update_col_1(connection, "django_mailman3_maildomain", "mail_domain")
            update_col_1(connection, "hyperkitty_mailinglist", "name",
                         where="name !~ 'lists.stg'")
            update_col_1(connection, "hyperkitty_mailinglist", "list_id",
                         where="list_id !~ 'lists.stg'")
    connection.commit()


def main():
    call(["systemctl", "stop", "webui-qcluster"])
    call(["systemctl", "stop", "mailman3"])
    call(["systemctl", "stop", "mailmanweb"])
    call(["systemctl", "stop", "httpd"])
    call(["systemctl", "stop", "crond"])
    do_mailman()
    do_django()
    call(["systemctl", "start", "crond"])
    call(["systemctl", "start", "httpd"])
    call(["systemctl", "start", "mailmanweb"])
    call(["systemctl", "start", "mailman3"])
    call(["systemctl", "start", "webui-qcluster"])


if __name__ == "__main__":
    main()
