#!/bin/bash

if [ -n "$1" ]; then
	DRIVE=/dev/$1
	if [ "$DRIVE" = "/dev/sda" ] ; then
		echo "Sorry, mount $DRIVE is not allowed..."
		exit 1
	fi
else
	echo -e "\nUsage: sudo $0 <device>\n"
	echo -e "Example: sudo $0 sdc\n"
	exit 1
fi

# umount partitions 
sudo umount ${DRIVE}1
sudo umount ${DRIVE}2

