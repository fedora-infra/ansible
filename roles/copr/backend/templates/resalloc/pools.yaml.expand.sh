#! /bin/bash

# Helper script to expand the pools.yaml.j2 file locally (on your box, not on
# Batcave), before you push the pools.yaml.j2 changes.  How to use:
#   1. execute this script for the first time to initiate $outdir
#   2. change the template
#   3. re-execute the script, and check `git show` in $outdir

pfx=pools-yaml-expander
pbook=/tmp/playbook-$pfx.yaml
outdir=/tmp/pools_debugging

sourcedir=$(dirname "$0")
gitroot=$(cd "$sourcedir" && git rev-parse --show-toplevel)
pools=$gitroot/roles/copr/backend/templates/resalloc/pools.yaml.j2

if ! test -d "$outdir"; then
    mkdir -p "$outdir"
    (cd "$outdir" && git init .)
fi


for i in devel production; do
    if test $i = production; then
        vars=$gitroot/inventory/group_vars/copr_aws
        file=pools.prod.yaml
    else
        vars=$gitroot/inventory/group_vars/copr_dev_aws
        file=pools.dev.yaml
    fi

    cat > $pbook <<EOF
---
- name: "expand Copr's pool.yaml from ansible.git"
  hosts: localhost
  connection: local
  vars_files:
    - $vars

  vars:
    provision_directory: /var/lib/resallocserver/provision
    ibmcloud_token_file: /var/lib/resallocserver/.ibm-cloud-token

  tasks:
    - name: instantiate $devel
      template:
        src: $pools
        dest: $outdir/$file

EOF

    ansible-playbook $pbook
done

(cd "$outdir" && git add *.yaml && git commit -m "update")
