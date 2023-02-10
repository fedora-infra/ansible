#! /usr/bin/python3

import time
import requests
from bs4 import BeautifulSoup
from prometheus_client import CollectorRegistry, write_to_textfile, Gauge


def collect_nagios_service_state(url, name, documentation, filename):
    registry = CollectorRegistry()
    gauge = Gauge(name, documentation, registry=registry)
    state = 0


    try:
        # Give the Nagios (our our network) some time to recover before we
        # pollute our Graphana metrics
        attempt = 0
        while True:
            attempt += 1
            try:
                response = requests.get(url)
                break
            except Exception:
                time.sleep(10)
                if attempt >= 4:
                    raise

        soup = BeautifulSoup(response.content, features="lxml")
        if soup.select_one("div.serviceOK"):
            state = 1
    except Exception:
        pass

    gauge.set(state)
    write_to_textfile(filename, registry)


if __name__ == '__main__':

    collect_nagios_service_state(
        "https://nagios.fedoraproject.org/nagios/cgi-bin/extinfo.cgi?type=2&host=copr-fe.aws.fedoraproject.org&service=The+copr+cdn+status",
        "fedora_copr_cdn_up",
        "1 if Nagios reports that AWS CloudFront CDN for Fedora Copr works fine",
        "/var/lib/prometheus/node-exporter/fedora_copr_cdn_up.prom",
    )

    collect_nagios_service_state(
        "https://nagios.fedoraproject.org/nagios/cgi-bin/extinfo.cgi?type=2&host=copr-be.aws.fedoraproject.org&service=The+copr-ping+package+builds",
        "fedora_copr_ping_package_ok",
        "1 if Nagios reports that the \"ping\" package builds fine in Fedora Copr",
        "/var/lib/prometheus/node-exporter/fedora_copr_ping_package_ok.prom",
    )
