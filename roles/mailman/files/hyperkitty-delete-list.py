#!/usr/bin/env python2

"""
Delete lists from HyperKitty

Author: Aurelien Bompard <abompard@fedoraproject.org>
"""

from __future__ import (
    absolute_import, print_function, unicode_literals, division)

import os
import logging
import readline
import sys
from argparse import ArgumentParser

sys.path.insert(0, "/srv/webui/config")
os.environ.setdefault("DJANGO_SETTINGS_MODULE", "settings")
from django import setup

from hyperkitty.models import MailingList


def delete_list(address):
    try:
        ml = MailingList.objects.get(name=address)
    except MailingList.DoesNotExist:
        print("Could not find a list with address \"{}\".".format(address))
        return
    print("The mailing-list \"{}\" ({}) will be entirely deleted.".format(ml.name, ml.list_id))
    print("It contains {} threads and {} emails.".format(ml.threads.count(), ml.emails.count()))
    prompt = "Are you sure? [y/N] ".format(ml.name, ml.list_id)
    response = raw_input(prompt)
    if response != "y":
        print("Not deleted.")
        return
    ml.delete()
    print("Mailing-list successfully deleted.")

def parse_args():
    parser = ArgumentParser()
    parser.add_argument("list_address", nargs="+", help="The mailing-list address")
    return parser.parse_args()


def main():
    args = parse_args()
    setup()
    logging.basicConfig(level=logging.INFO, format="%(message)s")
    for address in args.list_address:
        delete_list(address)


if __name__ == "__main__":
    main()
