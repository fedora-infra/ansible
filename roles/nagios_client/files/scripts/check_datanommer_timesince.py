#!/usr/bin/python3
""" NRPE check for datanommer/fedora-messaging health.
Given a category like 'bodhi', 'buildsys', or 'git', return an error if
datanommer hasn't seen a message of that type in such and such time.
You can alternatively provide a 'topic' which might look like
org.fedoraproject.prod.bodhi.update.comment.

Requires:  python-requests

Usage:

    $ check_datanommer_timesince CATEGORY WARNING_THRESH CRITICAL_THRESH

:Author: Aurelien Bompard <abompard@fedoraproject.org>

"""

import sys
from datetime import datetime, timezone

import requests


DATAGREPPER_URL = "https://apps.fedoraproject.org/datagrepper"


def query_messages(identifier, delta):
    params = {"delta": delta, "rows_per_page": 1, "page": 1}
    # If it has a '.', then assume it is a topic.
    if "." in identifier:
        params["topic"] = identifier
    else:
        params["category"] = identifier
    response = requests.get(f"{DATAGREPPER_URL}/v2/search", params=params)
    if not response.ok:
        print(f"UNKNOWN: Could not query {DATAGREPPER_URL}: error {response.status_code}")
        sys.exit(3)
    result = response.json()
    return result


def parse_args():
    def _usage():
        print(f"Usage: {sys.argv[0]} CATEGORY WARNING_THRESHOLD CRITICAL_THRESHOLD")
        sys.exit(3)

    if len(sys.argv) != 4:
        _usage()
    try:
        int(sys.argv[2])
        int(sys.argv[3])
    except ValueError:
        _usage()
    if int(sys.argv[2]) > int(sys.argv[3]):
        _usage()
    return sys.argv[1], int(sys.argv[2]), int(sys.argv[3])


def main():
    identifier, warning_threshold, critical_threshold = parse_args()
    result = query_messages(identifier, critical_threshold)

    if result["total"] == 0:
        print(f"CRIT: no {identifier} messages in {critical_threshold} seconds")
        sys.exit(2)

    last_timestamp = result["raw_messages"][0]["headers"]["sent-at"]
    last_timestamp = datetime.fromisoformat(last_timestamp)
    seconds_since = int((datetime.now(timezone.utc) - last_timestamp).total_seconds())
    reason = f"last {identifier} message was {seconds_since} seconds ago"

    if seconds_since > warning_threshold:
        print(f"WARN: {reason}")
        sys.exit(1)

    print(f"OK: {reason}")
    sys.exit(0)


if __name__ == "__main__":
    try:
        main()
    except Exception as e:
        print(f"UNKNOWN: {e}")
        sys.exit(3)
