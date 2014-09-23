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

# umount partitions first
sudo umount ${DRIVE}1
sudo umount ${DRIVE}2

# test if drive 1 is already mounted
mount | grep -q ${DRIVE}1
if [ $? -eq 1 ] ; then
	# create the directory
	sudo mkdir /media/boot

	#mount the partition
	echo -e "\nMount partition /media/boot..."
	sudo mount -t vfat ${DRIVE}1 /media/boot

	#test if the partition is mounted
	mount | grep -q ${DRIVE}1
	if [ $? -eq 1 ] ; then
		echo "Unable to mount /media/boot"
		exit 1
	else
		echo "${DRIVE}1 successfully mounted on /media/boot..."
	fi
else
	echo -e "\nParition ${DRIVE}1 already mounted on /media/boot..."
fi

	
# test if drive 2 is already mounted
mount | grep -q ${DRIVE}2
if [ $? -eq 1 ] ; then
	# create the directory
	sudo mkdir /media/rootfs

	#mount the partition
	echo -e "\nMount partition /media/rootfs..."
	sudo mount -t ext3 ${DRIVE}2 /media/rootfs

	#test if the partition is mounted
	mount | grep -q ${DRIVE}2
	if [ $? -eq 1 ] ; then
		echo "Unable to mount /media/rootfs"
		exit 1
	else
		echo "${DRIVE}2 successfully mounted on /media/rootfs..."
	fi
else
	echo -e "\nParition ${DRIVE}2 already mounted on /media/rootfs..."
fi	

