"""This script is used to generate fulltext search index from scratch."""
#!/usr/bin/env python
import argparse
import os
import sys
from subprocess import call

import django
from django.db import connection

# Read the database information from mailman config
sys.path.insert(0, '/etc/mailman3')
if not os.getenv("DJANGO_SETTINGS_MODULE"):
    os.environ["DJANGO_SETTINGS_MODULE"] = "settings"


# User to use for running mailman-web command
MAILMAN_USER = "mailman"


def get_mailinglists() -> list:
    """Get list of all the archived mailing lists."""
    mailinglists = []
    with connection.cursor() as cursor:
        print("Retriving list of archived mailinglists...")
        cursor.execute("SELECT name FROM hyperkitty_mailinglist")

        # This is needed to convert the results from list of tuple to
        # plain list
        for mailinglist in cursor:
            mailinglists.append(mailinglist[0])
        print("List retrieved: {0} entries".format(len(mailinglists)))

        return mailinglists


def generate_index(mailinglists: list) -> None:
    """Generate indexes for the lists one by one."""
    for mailinglist in mailinglists:
        print("Generating index for {0}".format(mailinglist))
        print("Generating index for {0} [{1}/{2}]".format(
            mailinglist, mailinglists.index(mailinglist) + 1, len(mailinglists)
            )
        )
        call(["sudo", "-u", MAILMAN_USER, "mailman-web", "update_index_one_list", mailinglist])
        print("Finished generating index for {0}".format(mailinglist))


if __name__ == "__main__":
    django.setup()
    parser = argparse.ArgumentParser(description=(
        "This script is used to generate fulltext search index from scratch. "
        "It will obtain the list of mailinglist, sort it alphabetically and "
        "generate index for them one by one."
        )
    )
    parser.add_argument('--start-from', dest="start_from", help="When generating index start from this mailing list.")
    args = parser.parse_args()
    mailinglists = get_mailinglists()
    mailinglists.sort()
    if args.start_from:
        # Check if the list exists in list
        if args.start_from in mailinglists:
            index = mailinglists.index(args.start_from)
            mailinglists = mailinglists[index:]

    generate_index(mailinglists)
