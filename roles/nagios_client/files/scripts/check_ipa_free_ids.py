#!/usr/bin/env python3

"""
Check for available IDs in IPA's ID ranges.

See pagure.io/fedora-infrastructure/issue/12641

Author: abompard@fedoraproject.org
"""

import os
import sys
from argparse import ArgumentParser
from configparser import ConfigParser

import ldap


STATUS_OK = 0
STATUS_WARNING = 1
STATUS_CRITICAL = 2
STATUS_UNKNOWN = 3


def get_config():
    config = ConfigParser(interpolation=None)
    config.read("/etc/ipa/default.conf")
    return {key: config.get("global", key) for key in ("host", "basedn")}


def get_ldap_connection(config):
    ldap.set_option(ldap.OPT_REFERRALS, 0)
    conn = ldap.ldapobject.SimpleLDAPObject(f"ldaps://{config['host']}")
    conn.protocol_version = 3
    conn.timeout = 10
    conn.sasl_gssapi_bind_s()
    return conn


def get_free_ids(config, connection):
    results = connection.search_s(
        base=f"cn=posix-ids,cn=dna,cn=ipa,cn=etc,{config['basedn']}",
        scope=ldap.SCOPE_ONELEVEL,
        filterstr="(dnaPortNum=389)",
        attrlist=["dnaHostname", "dnaRemainingValues"],
    )
    free_ids = {}
    for dn, attrs in results:
        hostname = attrs["dnaHostname"][0].decode("ascii")
        value = int(attrs["dnaRemainingValues"][0].decode("ascii"))
        free_ids[hostname] = value
    return free_ids


def get_nagios_result(free_ids):
    # Testcases:
    # free_ids={"host1": 0, "host2": 0, "host3": 20}
    # free_ids={"host1": 10, "host2": 0, "host3": 20}
    # free_ids={"host1": 10000, "host2": 10000, "host3": 20}
    # free_ids={}

    perfdata = " ".join(f"{host}={free_ids[host]}" for host in sorted(free_ids))
    if set(free_ids.values()) == {0}:
        msg = "CRITICAL: no free ID left"
        exit_code = 2
    elif 0 in set(free_ids.values()):
        full_servers = [host for host in sorted(free_ids) if free_ids[host] == 0]
        msg = " ".join(
            [
                "WARNING:",
                str(len(full_servers)),
                "server has" if len(full_servers) == 1 else "servers have",
                "no free ID left:",
                ", ".join(full_servers),
            ]
        )
        exit_code = 1
    elif any(value < 1000 for value in free_ids.values()):
        full_servers = [host for host in sorted(free_ids) if free_ids[host] < 1000]
        msg = " ".join(
            [
                "WARNING:",
                str(len(full_servers)),
                "server has" if len(full_servers) == 1 else "servers have",
                "almost no free ID left:",
                ", ".join(full_servers),
            ]
        )
        exit_code = 1
    else:
        msg = "OK: there are free IDs left"
        exit_code = 0
    return f"{msg}|{perfdata}", exit_code


def exit_nagios(output, exit_code):
    print(output)
    sys.exit(exit_code)


def parse_args():
    parser = ArgumentParser()
    parser.add_argument(
        "-k", "--keytab", help="use this keytab for GSSAPI authentication"
    )
    return parser.parse_args()


def main():
    args = parse_args()
    if args.keytab:
        os.environ["KRB5_CLIENT_KTNAME"] = args.keytab
    config = get_config()
    try:
        connection = get_ldap_connection(config)
        free_ids = get_free_ids(config, connection)
    except ldap.LOCAL_ERROR as e:
        exit_nagios(
            f"Can't read the free IDs in LDAP: {e.args[0].get('info')}", STATUS_UNKNOWN
        )

    if not free_ids:
        current_user = connection.whoami_s()
        exit_nagios(
            f"No IPA server found in LDAP, check the permissions for user {current_user!r}",
            STATUS_UNKNOWN,
        )

    exit_nagios(*get_nagios_result(free_ids))


if __name__ == "__main__":
    main()
