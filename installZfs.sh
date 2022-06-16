#!/bin/zsh

paru -Sy

g='/Version/{print $3}'
d1=$(paru -Qi zfs-dkms | gawk "$g")
d2=$(paru -Si zfs-dkms | gawk "$g")
u1=$(paru -Qi zfs-utils | gawk "$g")
u2=$(paru -Si zfs-utils | gawk "$g")

if [[ $d1 == $d2 || $u1 == $u2 ]]; then
	echo "zfs is up to date"
	exit 0
fi

paru -Sy zfs-dkms zfs-utils \
 --assume-installed zfs-dkms=$d1 --assume-installed zfs-dkms=$d2 \
 --assume-installed zfs-utils=$u1 --assume-installed zfs-utils=$u2
