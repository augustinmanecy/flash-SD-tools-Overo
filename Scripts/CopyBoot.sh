#!/bin/bash

if [ $# -ne 4 ]; then
	echo -e "\nUsage: sudo $0 <drive> <MLO name> <u-boot.img name> <uImage.bin name> \n"
	echo -e "Example: sudo $0 sdc MLO-overo u-boot-overo.img uImage-overo.bin\n"
	exit 1
fi

DRIVE=/dev/$1
mlo=$2
uboot=$3
uImage=$4

echo -e "\ncopying MLO..."
	sudo cp -v $mlo /media/boot/MLO
	if [ ! -e "/media/boot/MLO" ]; then
		echo "unable to copy MLO on SD card..."
		exit 1
	fi

echo -e "copying u-boot..."
	sudo cp -v $uboot /media/boot/u-boot.img
	if [ ! -e "/media/boot/u-boot.img" ]; then
		echo "unable to copy u-boot.img on SD card..."
		exit 1
	fi

echo -e "copying uImage...\n"
	sudo cp -v $uImage /media/boot/uImage
	if [ ! -e "/media/boot/uImage" ]; then
		echo "unable to copy uImage on SD card..."
		exit 1
	fi

echo -e "copying scripts to flash NAND...\n"
	mkimage -A arm -O linux -T script -C none -a 0 -e 0 -n "flash-MLO-uboot" -d ./Scripts/flash-MLO-uboot.cmd ./Scripts/flash-MLO-uboot.scr
	sudo cp ./Scripts/flash-MLO-uboot.scr /media/boot/flash-MLO-uboot.scr
	if [ ! -e "/media/boot/flash-MLO-uboot.scr" ]; then
		echo "unable to copy flash-MLO-uboot.scr on SD card..."
		exit 1
	fi
	mkimage -A arm -O linux -T script -C none -a 0 -e 0 -n "flash-MLO-uboot2" -d ./Scripts/flash-MLO-uboot2.cmd ./Scripts/flash-MLO-uboot2.scr
	sudo cp ./Scripts/flash-MLO-uboot2.scr /media/boot/flash-MLO-uboot2.scr
	if [ ! -e "/media/boot/flash-MLO-uboot2.scr" ]; then
		echo "unable to copy flash-MLO-uboot2.scr on SD card..."
		exit 1
	fi
	mkimage -A arm -O linux -T script -C none -a 0 -e 0 -n "flash-MLO-uboot3" -d ./Scripts/flash-MLO-uboot3.cmd ./Scripts/flash-MLO-uboot3.scr
	sudo cp ./Scripts/flash-MLO-uboot2.scr /media/boot/flash-MLO-uboot2.scr
	if [ ! -e "/media/boot/flash-MLO-uboot2.scr" ]; then
		echo "unable to copy flash-MLO-uboot2.scr on SD card..."
		exit 1
	fi
	
sync


