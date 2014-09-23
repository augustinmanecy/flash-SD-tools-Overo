#!/bin/bash

if [ $# -ne 1 ]; then
	echo -e "\nUsage: sudo $0 <rootfs.tar.XX name> \n"
	echo -e "Example: sudo $0 gumstix-console-image-overo.tar.bz2\n"
	echo -e "         sudo $0 gumstix-console-image-overo.tar.xz\n"
	exit 1
fi

echo -e "\nExpanding rootfs on /media/rootfs..."
	sudo tar xf $1 -C /media/rootfs 
	# check expand succeed
	if [ ! -e "/media/rootfs/etc" ]; then
		echo "can not expand to /media/rootfs/..."
		exit 1
	fi

echo -e "\nCopying expanded rootfs in /media/rootfs... May take several minutes..."
	sync

