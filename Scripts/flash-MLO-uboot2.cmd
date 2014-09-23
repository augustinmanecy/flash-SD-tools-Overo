# to run this script:
# 1) hit any key to stop the autoboot
# 2) when you entering in uboot, run:
#          mmc rescan; fatload mmc 0 ${loadaddr} flash-MLO-uboot2.scr; source ${loadaddr}

# rescan mmc to init sd card...
mmc rescan

# write the MLO
fatload mmc 0 ${loadaddr} MLO
nandecc hw
nand erase 0 80000
nand write ${loadaddr} 0 ${filesize}
nand write ${loadaddr} 20000 ${filesize}
nand write ${loadaddr} 40000 ${filesize}
nand write ${loadaddr} 60000 ${filesize}

# write the u-boot
fatload mmc 0 ${loadaddr} u-boot.img
nandecc hw
nand write ${loadaddr} 80000 ${filesize}

# erase u-boot environnement to enforce to load the default environnement
# nand erase 240000 20000

 
