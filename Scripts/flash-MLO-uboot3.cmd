# to run this script:
# 1) hit any key to stop the autoboot
# 2) when you entering in uboot, run:
#          mmc rescan; fatload mmc 0 ${loadaddr} flash-MLO-uboot3.scr; source ${loadaddr}

# rescan mmc to init sd card...
mmc rescan

# write the MLO
fatload mmc 0 $loadaddr MLO
nandecc hw
nand write $loadaddr 0 20000
nand write $loadaddr 20000 20000
nand write $loadaddr 40000 20000
nand write $loadaddr 60000 20000

# write the u-boot
fatload mmc 0 $loadaddr u-boot.img
nandecc hw
nand erase 80000 1c0000 
nand write $loadaddr 80000 ${filesize}

# erase u-boot environnement to enforce to load the default environnement
# nand erase 240000 20000

 
