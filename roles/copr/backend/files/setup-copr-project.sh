#! /bin/bash

# Execute this (on your box) to setup the package on the Copr side

script=$(readlink -f "$(dirname "$0")")/copr-custom-script

project=@copr/copr-ping
pkgname=copr-ping

build_deps=()
copr_cmd=(
    copr edit-package-custom "$project" \
        --webhook-rebuild on \
        --script "$script" \
        --script-chroot "fedora-latest-x86_64" \
        --script-builddeps "${build_deps[*]}"
        --max-builds 10
)

"${copr_cmd[@]}" --name "$pkgname"
