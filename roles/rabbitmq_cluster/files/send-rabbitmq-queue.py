#!/usr/bin/env python3

from argparse import ArgumentParser
from configparser import ConfigParser
from socket import getfqdn
from subprocess import run
from urllib.parse import quote

import requests


API_URL = "http://localhost:15672/api"
CONF_PATH = "/etc/nrpe.d/rabbitmq_args.ini"
VHOST = "/pubsub"
METRICS = ("messages", "messages_ready", "messages_unacknowledged")


def get_http_client(conf_path):
    config = ConfigParser()
    config.read(conf_path)
    client = requests.Session()
    client.auth = (config.get("common", "username"), config.get("common", "password"))
    return client


def parse_args():
    parser = ArgumentParser()
    parser.add_argument("queue_name", nargs="+")
    parser.add_argument(
        "--conf", default=CONF_PATH, help="path to NRPE's rabbitmq_args.ini file"
    )
    parser.add_argument("--vhost", default=VHOST, help="the rabbitmq vhost")
    parser.add_argument(
        "-s", "--host", default=getfqdn(), help="the server name in Zabbix"
    )
    parser.add_argument("--tls-psk-identity", help="passed down to zabbix_sender")
    parser.add_argument("--tls-psk-file", help="passed down to zabbix_sender")
    return parser.parse_args()


def get_queue_values(http, vhost, queue_name):
    response = http.get(f"{API_URL}/queues/{vhost}/{queue_name}")
    response.raise_for_status()
    data = response.json()
    return {metric: data[metric] for metric in METRICS}


def main():
    args = parse_args()
    http = get_http_client(args.conf)
    vhost = quote(args.vhost, safe="")
    zabbix_sender_args = []
    if args.tls_psk_identity:
        zabbix_sender_args.extend(
            [
                "--tls-connect",
                "psk",
                "--tls-psk-identity",
                args.tls_psk_identity,
                "--tls-psk-file",
                args.tls_psk_file,
            ]
        )
    zabbix_sender_args.extend(["--host", args.host])
    for queue_name in args.queue_name:
        data = get_queue_values(http, vhost, queue_name)
        for metric, value in data.items():
            command = [
                "zabbit_sender",
                *zabbix_sender_args,
                "--key",
                f"rabbitmq.queue.{queue_name}.{metric}"
                "--value",
                str(value),
            ]
            print(" ".join(command))
            # run(command, check=True)


if __name__ == "__main__":
    main()
