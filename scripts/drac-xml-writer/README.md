This tool generates XML files to be uploaded to Dell iDRAC consoles

# Requirements

- `pandas` for the DHCP parser
- `racadm` to talk to the Dells

# Usage

1. Put a list of IPs in `hostnames.csv` - 2 IPs are given as an example
2. Run `dhcp_parser.py`
    1. This will reference the IPs and lookup the hostnames that match
    2. The output is written back to hostnames.csv
3. (optional) Export a known-good XML from a DRAC host, and place it in drac-prod.xml.base
    1. **This is optional, the repo contains our current XML with the edits already done**
    2. e.g. `sudo racadm -r <ip> -u admin -p "supersecret" get -f ./drac-prod.xml.base -t xml --clone`
    3. Edit NIC.1#DNSRacName and replace the hostname with PLACEHOLDER, like this:
       - `<Attribute Name="NIC.1#DNSRacName">PLACEHOLDER</Attribute>`
    4. Edit the Users and comment out the passwords for the relevant users
       - `<!-- <Attribute Name="Users.2#Password"></Attribute> -->`
4. Edit `xml_writer` to set the passwords used for the prod and stg environments (lines 47, 50, 56 & 59)
4. Run `python xml_writer.py`

# Output

This will generate 2 directories and 4 scripts.

The directories are called `prod` and `stg` and contain the customised XML for
each target host in the IP list.

The files are `prod.sh`, `stg.sh`, `prod_test.sh` and `stg_test.sh`. Run the
test scripts first - these simply use `racadm` to test the user/password works
for each host. `racadm` can be noisy, so run it like this:

```
bash ./stg_test.sh 2>&1 |grep -E "(10.16|ERROR)"
```

Obviously replace the 10.16 with the real IPs - you want to match all the
hosts but not the random text `racadm` spews out

If any fail, check the access manually, and re-run until then work.

Then run the main script, eg `bash stg.sh` which will apply the custom XML from
the directory to the each host in series.


You can run the test script another time after to check access still works
