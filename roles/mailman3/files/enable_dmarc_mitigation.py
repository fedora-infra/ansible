#!/usr/bin/python3

"""
This script is for enabling DMARC mitigation in mailman3 for
any list that doesn't have the policy enabled.
For more info about DMARC mitigation in mailman3 see
https://docs.mailman3.org/projects/mailman/en/latest/src/mailman/handlers/docs/dmarc-mitigations.html

For more info why Fedora is doing this see
https://pagure.io/fedora-infrastructure/issue/11427

The script will set dmarc_mitigate related columns
in `mailman` table to preferred values.
"""

import configparser
import psycopg2

MAILINGLIST_TABLE = "mailinglist"
DMARC_MITIGATE_ACTIONS = {
    "no_mitigation": 0,
    "munge_from": 1,
    "wrap_message": 2,
    "reject": 3,
    "discard": 4
}
# Default DMARC values we want to set
DEFAULT_DMARC_MITIGATE_ACTION = 1  # munge_from option
DEFAULT_DMARC_MITIGATE_UNCONDITIONALLY = True  # Apply to everything

# Read the database information from mailman config
config = configparser.ConfigParser()
config.read('/etc/mailman.cfg')
db_connect_url = config["database"]["url"]
conn = psycopg2.connect(db_connect_url)

try:
    with conn.cursor() as cursor:
        # Obtain all mailing lists that don't have DMARC mitigation enabled
        cursor.execute(
            "SELECT id FROM {} WHERE dmarc_mitigate_action={}".format(
                MAILINGLIST_TABLE, DMARC_MITIGATE_ACTIONS["no_mitigation"]
            )
        )
        rows = cursor.fetchall()
        update_data = []
        for row in rows:
            update_data.append(row[0])

        print("Will update {0} rows".format(len(update_data)))
        # Update DMARC mitigation action
        for row_id in update_data:
#            print(
#                "UPDATE {0} SET dmarc_mitigate_action = {1}, dmarc_mitigate_unconditionally = {2} WHERE id = {3}".format(
#                    MAILINGLIST_TABLE,
#                    DEFAULT_DMARC_MITIGATE_ACTION,
#                    DEFAULT_DMARC_MITIGATE_UNCONDITIONALLY,
#                    row_id
#                )
#            )
            cursor.execute(
                "UPDATE {0} SET dmarc_mitigate_action = {1}, dmarc_mitigate_unconditionally = {2} WHERE id = {3}".format(
                    MAILINGLIST_TABLE,
                    DEFAULT_DMARC_MITIGATE_ACTION,
                    DEFAULT_DMARC_MITIGATE_UNCONDITIONALLY,
                    row_id
                )
            )

        conn.commit()
    print("Updated rows: {}".format(len(update_data)))
except (Exception, psycopg2.DatabaseError) as error:
    print(error)
