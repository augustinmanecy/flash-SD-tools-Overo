#!/bin/bash

# usage:   sudo ./GenereBootableSD.sh <device>\n"
# Example: sudo ./GenereBootableSD.sh sdc\n"
#
# Before running this script please make sure that it is the good device:
# 	Check with: 
#			sudo fdisk -l /dev/<device>
#	   example:	sudo fdisk -l /dev/sdc

mlo=MLO-overo
uboot=u-boot-overo.img
uImage=uImage_RT-MaG_Overo.bin
rootfs=rootfs_RT-MaG_Overo.tar.xz

ImagePath=home/root/image
PatchsPath=home/root/patch

if [ -n "$1" ]; then
	DRIVE=/dev/$1
else
	echo -e "\nUsage: sudo $0 <device>\n"
	echo -e "Example: sudo $0 sdc\n"
	exit 1
fi

echo -e "\nMake partition on SD card..."
	sudo ./Scripts/mk2parts.sh $1
	if [ $? -eq 1 ] ; then
		echo "Unable to create partitions..."
		exit 1
	fi

echo -e "\nFormate the partitions..."
	sudo ./Scripts/FormatParts.sh $1
	if [ $? -eq 1 ] ; then
		echo "Unable to Format SD card..."
		exit 1
	fi

echo -e "\nMounting boot and rootfs in /media/..."
	sudo ./Scripts/MountSD.sh $1
	if [ $? -eq 1 ] ; then
		echo "Unable to mount SD card..."
		exit 1
	fi

echo -e "\nCopying the boot files..."
	sudo ./Scripts/CopyBoot.sh $1 $mlo $uboot $uImage
	if [ $? -eq 1 ] ; then
		echo "Unable to copy boot files..."
		exit 1
	fi

echo -e "\nExpand rootfs files..."
	sudo ./Scripts/ExpandRootfs.sh $rootfs
	if [ $? -eq 1 ] ; then
		echo "Unable to expand rootfs..."
		exit 1
	fi

echo -e "\nCopying necessary files to flash NAND in $ImagePath"
	sudo mkdir /media/rootfs/$ImagePath
	echo -e "\tCopying Script: FlashNand.sh and make it executable..."
		sudo cp -v ./Scripts/FlashNand.sh /media/rootfs/$ImagePath
		sudo chmod +x /media/rootfs/$ImagePath/FlashNand.sh
	echo -e "\tCopying MLO..."
		sudo cp -v $mlo /media/rootfs/$ImagePath/MLO
		if [ ! -e "/media/rootfs/$ImagePath/MLO" ]; then
			echo "unable to copy MLO on /media/rootfs/$ImagePath/..."
			exit 1
		fi
	echo -e "\tCopying u-boot..."
		sudo cp $uboot /media/rootfs/$ImagePath/u-boot.img
		if [ ! -e "/media/rootfs/$ImagePath/u-boot.img" ]; then
			echo "unable to copy u-boot.img on /media/rootfs/$ImagePath/..."
			exit 1
		fi
	echo -e "\tCopying uImage..."
		sudo cp -v $uImage /media/rootfs/$ImagePath/uImage
		if [ ! -e "/media/rootfs/$ImagePath/uImage" ]; then
			echo "unable to copy uImage on /media/rootfs/$ImagePath/..."
			exit 1
		fi
	echo -e "\tCopying rootfs..."
		sudo ./Scripts/tar2ubi.sh $rootfs
		sudo cp -v rootfs.ubi /media/rootfs/$ImagePath/rootfs.ubi
		if [ ! -e "/media/rootfs/$ImagePath/rootfs.ubi" ]; then
			echo "unable to copy rootfs.ubi on /media/rootfs/$ImagePath/..."
			exit 1
		fi	
		sudo cp -v rootfs-bb.ubi /media/rootfs/$ImagePath/rootfs-bb.ubi
		if [ ! -e "/media/rootfs/$ImagePath/rootfs.ubi" ]; then
			echo "unable to copy rootfs-bb.ubi on /media/rootfs/$ImagePath/..."
			exit 1
		fi	
		sudo cp ./Scripts/FlashNand2.sh /media/rootfs/$ImagePath/FlashNand2.sh
		if [ ! -e "/media/rootfs/$ImagePath/rootfs.ubi" ]; then
			echo "unable to copy rootfs-bb.ubi on /media/rootfs/$ImagePath/..."
			exit 1
		fi	
		sudo chmod +x /media/rootfs/$ImagePath/FlashNand2.sh
	sync

echo -e "\nWaiting pending copies before unmount SD card..."
	sudo ./Scripts/uMountSD.sh $1

echo -e "\nUnmounting SD card..."
	sudo ./Scripts/uMountSD.sh $1

echo -e "\n=== DONE ==="

