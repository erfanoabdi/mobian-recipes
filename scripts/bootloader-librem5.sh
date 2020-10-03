#!/bin/sh

wget -O /boot/librem5-boot.img \
https://arm01.puri.sm/job/u-boot_builds/job/uboot_librem5_build/lastSuccessfulBuild/artifact/output/uboot-librem5/librem5-boot.img

# Rename kernel boot files so they're recognized by u-boot
KERNEL_VERSION=`ls /lib/modules | grep librem`
/etc/kernel/postinst.d/zz-rename-files $KERNEL_VERSION
