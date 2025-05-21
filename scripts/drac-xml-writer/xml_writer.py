#!/usr/bin/env python

import os
import csv

# Read the CSV file
with open('./hostnames.csv', newline='') as csvfile:
    reader = csv.DictReader(csvfile)
    servers = list(reader)

stg_script = "stg.sh"
if os.path.exists(stg_script):
    os.remove(stg_script)

stg_test_script = "stg_test.sh"
if os.path.exists(stg_test_script):
    os.remove(stg_test_script)

prod_script = "prod.sh"
if os.path.exists(prod_script):
    os.remove(prod_script)

prod_test_script = "prod_test.sh"
if os.path.exists(prod_test_script):
    os.remove(prod_test_script)

user = 'root'

# Read the template XML as a string
with open('./drac-prod.xml.base', 'r', encoding='utf-8') as f:
    template = f.read()

for server in servers:
    ip = server['ip']
    name = server['name']
    stg = server['stg']

    # Replace the placeholder with the actual name
    xml_content = template.replace(
        '<Attribute Name="NIC.1#DNSRacName">PLACEHOLDER</Attribute>',
        f'<Attribute Name="NIC.1#DNSRacName">{name}</Attribute>'
    )
    # Write to a new XML file named after the IP
    if stg == "True":
        filename = f'stg/{ip}.xml'
        with open(stg_script, 'a', encoding='utf-8') as f:
            f.write(f"sudo racadm -r {ip} -u {user} -p 'stg-password' set -f ./stg/{ip}.xml -t xml -s Off\n")
        with open(stg_test_script, 'a', encoding='utf-8') as f:
            f.write(f"echo {ip}\n")
            f.write(f"sudo racadm -r {ip} -u {user} -p 'stg-password' getsvctag\n")
        with open(filename, 'w', encoding='utf-8') as f:
            f.write(xml_content)
    else:
        filename = f'prod/{ip}.xml'
        with open(prod_script, 'a', encoding='utf-8') as f:
            f.write(f"sudo racadm -r {ip} -u {user} -p 'prod-password' set -f ./prod/{ip}.xml -t xml -s Off\n")
        with open(prod_test_script, 'a', encoding='utf-8') as f:
            f.write(f"echo {ip}\n")
            f.write(f"sudo racadm -r {ip} -u {user} -p 'prod-password' getsvctag\n")
        with open(filename, 'w', encoding='utf-8') as f:
            f.write(xml_content)
