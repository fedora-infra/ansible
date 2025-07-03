#!/usr/bin/env python

import re
import pandas as pd

# File paths
ips_csv = './hostnames.csv'
dhcp_data = '/srv/web/infra/ansible/roles/dhcp_server/files/dhcpd.conf.noc01.rdu3.fedoraproject.org'

# Read the CSV
ips = pd.read_csv(ips_csv)

# Read the DHCP config file into a list of lines
with open(dhcp_data, 'r', encoding='utf-8') as f:
    dhcp_lines = f.readlines()

def get_name(ip):
    # Search for the line containing the IP address
    for idx, line in enumerate(dhcp_lines):
        if ip in line:
            # Get the next line (like grep -A1)
            if idx + 1 < len(dhcp_lines):
                next_line = dhcp_lines[idx + 1]
                # Extract the hostname using the regex
                match = re.search(r'"(.*)\.mgmt', next_line)
                if match:
                    return match.group(1)
            break
    return None  # Return None if not found

def get_stg(ip):
    # Search for the line containing the IP address
    for idx, line in enumerate(dhcp_lines):
        if ip in line:
            # Get the next line (like grep -A1)
            if idx + 1 < len(dhcp_lines):
                next_line = dhcp_lines[idx + 1]
                # Extract the hostname using the regex
                match = re.search(r'stg', next_line)
                if match:
                    return True
                else:
                    return False
            break
    return None  # Return None if not found

# Apply the function to each IP
ips['name'] = ips['ip'].apply(get_name)
ips['stg'] =  ips['ip'].apply(get_stg)

# Write the updated DataFrame back to CSV
ips.to_csv('./hostnames.csv', index=False)
