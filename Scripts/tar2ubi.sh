#!/bin/bash

if [ $# -ne 1 ]; then
	echo -e "\nUsage: sudo $0 <rootfs.tar.XX name> \n"
	echo -e "Example: sudo $0 gumstix-console-image-overo.tar.bz2\n"
	echo -e "         sudo $0 gumstix-console-image-overo.tar.xz\n"
	exit 1
fi

rootfs=$1

# theses following argument could be obtained by running on your gumstix (you need to have the packages "mtd-utils" and "mtd-utils-ubifs" on your gumstix):
#
#     root@overo~# mtdinfo /dev/mtd4
#
#	We check info about mtd4 because it is the partition were rootfs will be installed... 
#
# if you don't know what to give, use the default: 
#   eraseBlocksNb=1996		# correspond to "Amount of eraseblocks"
#   eraseBlockSize=129024	# correspond to "Eraseblock size" in bytes - minIOsize (ex: 128KiB => 128*1024 = 131072 - 2048 = 129024)
				# NB: The logical ereaseBlockSize (LEB) correspond to the physical eraseBlockSize (PEB) minus the minimum 					  input/output unit size. The "Eraseblock size" given by "mtdinfo" correspond to the PEB's size.
#   minIOsize=2048		# correspond to "Minimum input/output unit size" in bytes

eraseBlocksNb=4012		# correspond to "Amount of eraseblocks"
eraseBlockSize=129024		# correspond to "Eraseblock size" in bytes - minIOsize (ex: 126KiB => 126*1024 = 129024)
				# NB: The logical ereaseBlockSize (LEB) correspond to the physical eraseBlockSize (PEB) minus the minimum 					  input/output unit size. The "Eraseblock size" given by "mtdinfo" correspond to the PEB's size.
minIOsize=2048			# correspond to "Minimum input/output unit size" in bytes

echo -e "\nCreating .ubi file from archive..."
	echo -e "\tUntaring archive in current directory..."
	sudo rm -r rootfs
	sudo mkdir rootfs
	sudo tar xf $rootfs -C rootfs
	sudo chmod g+w rootfs
	echo -e "\tCreating rootfs.ubi..."
	sudo rm rootfs.ubi rootfs.ubifs
	sudo mkfs.ubifs -v -r rootfs -o rootfs.ubifs -m $minIOsize -e $eraseBlockSize -c $eraseBlocksNb
	# check that file have been correctly created
	if [ -e "rootfs.ubifs" ]; then
		echo "rootfs.ubifs successfully created!"
	else
		echo "unable to create rootfs.ubifs"
		exit 1
	fi
	sudo ubinize -v -o rootfs.ubi -m 2048 -p 128KiB -s 512 ./Scripts/ubinize.cfg
	# check that files have been correctly created
	if [ -e "rootfs.ubi" ]; then
		echo "rootfs.ubi successfully created!"
	else
		echo "unable to create rootfs.ubi"
		exit 1
	fi
	# give write right to user's group
	sudo chmod g+w rootfs.ubi rootfs.ubifs
	

