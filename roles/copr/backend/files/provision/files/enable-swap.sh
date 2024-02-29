#!/usr/bin/bash

set -x
set -e

part_suffix=p
swap_device=

generic_mount()
{
    # Find a "very large" volume — that one will be used (IBM Cloud assigns the
    # swap volume name randomly, hypervisors have /var/vdb).
    for vol in /dev/vdb /dev/vdc /dev/vdd /dev/vda; do
       mount | grep $vol && continue
       size=$(blockdev --getsize64 "$vol")
       test "$size" -le 150000000000 && continue
       swap_device=$vol
       part_suffix=
       break
    done
}


if test -f /config/resalloc-vars.sh; then
    # VMs on our hypervisors have this file created, providing some basic info
    # about the "pool ID" (== particular hypervisor).
    generic_mount
elif grep POWER9 /proc/cpuinfo; then
    # OpenStack Power9 only for now.  We have only one large volume there.
    # Partitioning using cloud-init isn't trival, especially considering we
    # share the Power8 and Power9 builder images so we create a swap file
    # on / filesystem.
    file=/sub-mounts-file
    swap_device_base=loop5
    swap_device=/dev/$swap_device_base
    truncate -s 164G "$file"
    losetup "$swap_device_base" "$file"
elif test -e /dev/xvda1 && test -e /dev/nvme0n1; then
    # AWS aarch64 machine.  We use separate volume allocation as the default
    # root disk in our instance type is too small.
    swap_device=/dev/nvme0n1
elif test -e /dev/nvme1n1; then
    # AWS x86_64 machine.  There's >= 400G space on the default volume in our
    # instance type.
    swap_device=/dev/nvme1n1
else
    # This should be a machine in IBM Cloud
    generic_mount
fi

test -n "$swap_device"

systemctl unmask tmp.mount
systemctl start tmp.mount

if ! echo "\
n
p


+16G
n
p
2


w
" | fdisk "$swap_device"
then
  # fdisk is known to fail on loop devices (TODO: report this)
  case $swap_device in
  *loop*)
      partx "$swap_device"  -a
      ;;
  *)
      # non-loop device, fdisk shouldn't fail ...
      false
      ;;
  esac
fi


mkfs.ext4 "${swap_device}${part_suffix}1"

mount "$swap_device${part_suffix}1" /var/lib/copr-rpmbuild
mkdir /var/lib/copr-rpmbuild/results
mkdir /var/lib/copr-rpmbuild/workspace
rpm --setperms copr-rpmbuild || :
rpm --setugids copr-rpmbuild || :

# Wait till the partition appears
partprobe || :
partition=${swap_device}${part_suffix}2
while ! test -e "$partition"; do
    sleep 0.1
done

mkswap "$partition"
swapon "$partition"
