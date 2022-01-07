#!/usr/bin/bash

set -x
set -e

part_suffix=p
swap_device=
if test -e /dev/xvda1 && test -e /dev/nvme0n1; then
    # AWS aarch64 machine.  We use separate volume allocation as the default
    # root disk in our instance type is too small.
    swap_device=/dev/nvme0n1
elif test -e /dev/nvme1n1; then
    # AWS x86_64 machine.  There's >= 400G space on the default volume in our
    # instance type.
    swap_device=/dev/nvme1n1
else
    # LibVirt (on-premise) machine, or the IBM Cloud machine.  Find the "large"
    # volume, that one will be used.
    for vol in /dev/vdb /dev/vdd; do
       mount | grep $vol && continue
       size=$(blockdev --getsize64 "$vol")
       test "$size" -le 150000000000 && continue
       swap_device=$vol
       part_suffix=
       break
    done
fi

test -n "$swap_device"

systemctl unmask tmp.mount
systemctl start tmp.mount


echo "\
n
p


+16G
n
p
2


w
" | fdisk "$swap_device"

mkfs.ext4 "${swap_device}${part_suffix}1"

mount "$swap_device${part_suffix}1" /var/lib/copr-rpmbuild
mkdir /var/lib/copr-rpmbuild/results
mkdir /var/lib/copr-rpmbuild/workspace
rpm --setperms copr-rpmbuild || :
rpm --setugids copr-rpmbuild || :

mkswap "${swap_device}${part_suffix}2"
swapon "${swap_device}${part_suffix}2"
