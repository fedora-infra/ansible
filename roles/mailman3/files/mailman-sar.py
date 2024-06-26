#!/usr/bin/env python
"""
GDPR SAR script for HyperKitty.

Extract all emails from a selected address and prints them in JSON to the
standard output.
"""

import argparse
import json
import logging
import os
import sys

from configparser import ConfigParser
from six.moves.urllib.parse import urljoin
import requests

config = ConfigParser()
config.read("/etc/mailman.cfg")
username = config.get("webservice", "admin_user")
userpass = config.get("webservice", "admin_pass")

ENV_EMAIL = "SAR_EMAIL"
HYPERKITTY_INSTANCE = "http://localhost/archives/"
MAILMAN_INSTANCE = "http://localhost:8001/"
MAILMAN_AUTH = (username, userpass)

log = logging.getLogger()


def get_emails(address):
    url = urljoin(HYPERKITTY_INSTANCE, "api/sender/{}/emails/".format(address))
    email_urls = []
    response = requests.get(url)
    if response.status_code >= 300:
        log.error("Could not get URL %s: %d %s",
                  url, response.status_code, response.reason)
        raise ConnectionError
    result = response.json()
    email_urls.extend([e["url"] for e in result])
    emails = []
    for url in email_urls:
        response = requests.get(url)
        result = response.json()
        emails.append(result)
    return emails


def get_subscriptions(address):
    url = urljoin(MAILMAN_INSTANCE,
                  "3.1/members/find?subscriber={}".format(address))
    response = requests.get(url, auth=MAILMAN_AUTH)
    if response.status_code >= 300:
        log.error("Could not get URL %s: %d %s",
                  url, response.status_code, response.reason)
        return []
    result = response.json()
    subscriptions = []
    for entry in result.get("entries", []):
        subscription = {
            "list_id": entry["list_id"],
            "role": entry["role"],
            "delivery_mode": entry["delivery_mode"],
        }
        # Get the subscription's preferences
        member_id = entry["member_id"]
        pref_url = urljoin(MAILMAN_INSTANCE,
                           "3.1/members/{}/preferences".format(member_id))
        pref_response = requests.get(pref_url, auth=MAILMAN_AUTH)
        pref_result = pref_response.json()
        if pref_response.status_code >= 300:
            log.error("Could not get URL %s: %d %s",
                      pref_url, pref_response.status_code,
                      pref_response.reason)
        else:
            subscription["preferences"] = dict([
                (key, pref_result[key]) for key in pref_result
                if key not in ("http_etag", "self_link")
            ])
        subscriptions.append(subscription)
    return subscriptions


def parse_args():
    parser = argparse.ArgumentParser()
    parser.add_argument("--debug", action="store_true")
    return parser.parse_args()


def main():
    args = parse_args()
    try:
        email = os.environ[ENV_EMAIL]
    except KeyError as e:
        print("Missing environment variable. {}".format(e), file=sys.stderr)
        sys.exit(1)
    logging.basicConfig(
        level=logging.DEBUG if args.debug else logging.WARNING,
        stream=sys.stderr,
    )
    emails = get_emails(email)
    subscriptions = get_subscriptions(email)
    print(json.dumps(dict(
        emails=emails,
        subscriptions=subscriptions,
    ), indent=2))


if __name__ == "__main__":
    main()
