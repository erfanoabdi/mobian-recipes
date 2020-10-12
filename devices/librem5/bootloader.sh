#!/bin/sh

# Rename kernel boot files so they're recognized by u-boot
KERNEL_VERSION=`ls /lib/modules`
/etc/kernel/postinst.d/zz-rename-files $KERNEL_VERSION
