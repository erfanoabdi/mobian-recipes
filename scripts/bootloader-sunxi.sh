#!/bin/sh

BOARD="$1"

# Install u-boot to dummy bootsector
dd if=/dev/zero of=/tmp/bootsector.bin bs=8k count=6
TARGET="/usr/lib/u-boot/$BOARD" u-boot-install-sunxi64 -f /tmp/bootsector.bin

# Extract full u-boot binary
dd if=/tmp/bootsector.bin of=/boot/u-boot-sunxi-with-spl.bin bs=8k skip=1
