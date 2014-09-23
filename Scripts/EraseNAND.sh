#!/bin/bash

uboot=./../mmcblk0p1/u-boot.img
uimage=./../mmcblk0p1/uImage.bin
rootfs=./../mmcblk0p2/rootfs-overo.ubi

if [ -e $uboot ]; then
  echo "Erasing u-boot partition ..."
  flash_erase /dev/mtd1 0 0
  echo "Erasing u-boot environment partition ..."
  flash_erase /dev/mtd2 0 0
  echo "Writing u-boot to NAND ..."
  nandwrite -p /dev/mtd1 $uboot
else
  echo "ERROR:  couldn't find u-boot binary"
fi

if [ -e $uimage ]; then                 
  echo "Erasing kernel partition ..."            
  flash_erase /dev/mtd3 0 0                      
  echo "Writing kernel to NAND ..."         
  nandwrite -p /dev/mtd3 $uimage
else                                             
  echo "ERROR:  couldn't find kernel binary"     
fi
                                               
if [ -e $rootfs ]; then
  umount /dev/mtdblock4
  echo "Writing rootfs to NAND ..."
  ubiformat -y /dev/mtd4 -f $rootfs
else
  echo "ERROR:  couldn't find rootfs ubi"
fi


