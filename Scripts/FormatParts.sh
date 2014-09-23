#!/bin/bash

if [ -n "$1" ]; then
	DRIVE=/dev/$1
	if [ "$DRIVE" = "/dev/sda" ] ; then
		echo "Sorry, format $DRIVE is not allowed..."
		exit 1
	fi
else
	echo -e "\nUsage: sudo $0 <device>\n"
	echo -e "Example: sudo $0 sdc\n"
	exit 1
fi

echo -e "formating partition boot...\n\n"
	sudo mkfs.vfat -F 32 ${DRIVE}1 -n boot

echo -e "formatting partition rootfs...\n\n"
	sudo mke2fs -j -L rootfs ${DRIVE}2

echo -e "\n== Done ==\n"
