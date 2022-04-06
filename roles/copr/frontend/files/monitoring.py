#! /usr/bin/python3

import requests
from bs4 import BeautifulSoup
from prometheus_client import CollectorRegistry, write_to_textfile, Gauge


class TextfileCollector:
    NAGIOS_URL = 'https://nagios.fedoraproject.org/nagios/cgi-bin//avail.cgi'

    def __init__(self, url, name, documentation, css_selector, filename):
        self.registry = CollectorRegistry()
        self.url = url
        self.css_selector = css_selector
        self.filename = filename
        self.copr_cdn_status = Gauge(name, documentation, registry=self.registry)

    def collect_data(self):
        url = self.NAGIOS_URL + self.url
        r = requests.get(url)
        html = r.text
        soup = BeautifulSoup(html, features="lxml")
        service_ok = soup.select_one(self.css_selector)
        return service_ok.text.strip('%')

    def set(self, data):
        self.copr_cdn_status.set(data)
        write_to_textfile(self.filename, self.registry)


def collect(url, name, documentation, css_selector, filename):
    textfile_collector = TextfileCollector(url, name, documentation, css_selector, filename)
    percentage = textfile_collector.collect_data()
    textfile_collector.set(percentage)


if __name__ == '__main__':
    copr_cdn_url = "?show_log_entries=&full_log_entries=&" \
                   "host=copr-fe.aws.fedoraproject.org&service=The+copr+cdn+status&assumeinitialstates=yes&" \
                   "assumestateretention=yes&assumestatesduringnotrunning=yes&includesoftstates=no&" \
                   "initialassumedhoststate=0&initialassumedservicestate=0&timeperiod=last31days&backtrack=4"
    copr_ping_url = "?show_log_entries=&host=copr-be.aws.fedoraproject.org&" \
                    "service=The+copr-ping+package+builds&assumeinitialstates=yes&assumestateretention=yes&" \
                    "assumestatesduringnotrunning=yes&includesoftstates=no&initialassumedhoststate=0&" \
                    "initialassumedservicestate=0&timeperiod=last31days&backtrack=4"
    collect(copr_cdn_url, "copr_cdn_status", "Copr's CDN status", "td.serviceOK:nth-child(4)",
            "/var/lib/node_exporter/textfile_collector/copr_cdn_status.prom.new")
    collect(copr_ping_url, "copr_ping_status", "Status of build of copr-ping package", "td.serviceOK:nth-child(4)",
            "/var/lib/node_exporter/textfile_collector/copr_ping_status.prom.new")
