#!/usr/bin/python3

"""
This script is to migrate users from OpenID Fedora auth provider to newer
OpendID Connect Fedora auth provider.
The provider is in django_mailman3 package
https://packages.fedoraproject.org/pkgs/python-django-mailman3/

The migration scripts changes UID in socialaccount_socialaccount table
in hyperkitty DB from `http://<username>.id.fedoraproject.org/` to simple
`<username>`.
"""

import psycopg2
import re
import sys

SOCIALACCOUNT_TABLE = "socialaccount_socialaccount"
OPENID_REGEX = r"http://(.+).id.fedoraproject.org/"

# Read the database information from mailman config
sys.path.append('/etc/mailman3')
import settings
database_settings = settings.DATABASES.get("default")
conn = psycopg2.connect(
        host=database_settings["HOST"],
        user=database_settings["USER"],
        password=database_settings["PASSWORD"],
        port=database_settings["PORT"],
        dbname=database_settings["NAME"],
        )

try:
    with conn.cursor() as cursor:
        # Obtain all users with fedora provider
        cursor.execute("SELECT id, uid FROM {} WHERE provider='fedora'".format(SOCIALACCOUNT_TABLE))
        rows = cursor.fetchall()
        update_data = []
        for row in rows:
            result = re.search(OPENID_REGEX, row[1])
            if result:
                update_data.append((row[0], result.group(1)))
                #print("old_uid: '{0}' -> new_uid: '{1}'".format(row[1], result.group(1)))
            #else:
            #    print("User {0} seems to be already migrated".format(row[1]))

        print("Obtained {0}, will update {1}".format(len(rows), len(update_data)))
        # Update uid for the retrieved users
        for row in update_data:
            cursor.execute("UPDATE {0} SET uid = '{1}' WHERE id = {2}".format(SOCIALACCOUNT_TABLE, row[1], row[0]))

        conn.commit()
    print("Updated rows: {}".format(len(update_data)))
except (Exception, psycopg2.DatabaseError) as error:
    print(error)
