#!/bin/bash

for dname in */; do
  dname="${dname%%/}"
  downer="$(stat --format %U "$dname")"
  # skip directories owned by root
  if [ "$downer" = "root" ]; then
    continue
  fi
  # verify that the directory actually is the home directory of the same-named user
  IFS=":" read -r _ _ _ _ _ homedir _ < <(getent passwd "$dname")
  if [ "$homedir" != "/home/fedora/$dname" ]; then
    continue
  fi
  echo "fixing ownership: $dname"
  chown -R "$dname:" "$dname"
done
