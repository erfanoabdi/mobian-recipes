#!/bin/sh

BOARD="$1"

cat > /etc/default/u-boot << EOF
## /etc/default/u-boot - configuration file for u-boot-update(8)

U_BOOT_UPDATE="true"
U_BOOT_MENU_LABEL="Mobian GNU/Linux"
U_BOOT_PARAMETERS="console=ttyS0,115200 consoleblank=0 loglevel=7 rw splash plymouth.ignore-serial-consoles vt.global_cursor_default=0"
U_BOOT_TIMEOUT="10"
U_BOOT_ROOT=""
U_BOOT_FDT_DIR="/dtb-"

EOF

# Install u-boot to dummy bootsector
dd if=/dev/zero of=/tmp/bootsector.bin bs=8k count=6
TARGET="/usr/lib/u-boot/$BOARD" u-boot-install-sunxi64 -f /tmp/bootsector.bin

# Extract full u-boot binary
dd if=/tmp/bootsector.bin of=/boot/u-boot-sunxi-with-spl.bin bs=8k skip=1

# Rename kernel boot files so they're recognized by u-boot
KERNEL_VERSION=`linux-version list`
/etc/kernel/postinst.d/zz-sync-dtb $KERNEL_VERSION

# Create boot menu file for u-boot
u-boot-update
