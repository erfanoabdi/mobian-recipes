#!/bin/sh

DEVICE="$1"

# PineTab uses the same config file as PinePhone
if [ $DEVICE = "pinetab" ]; then
    DEVICE="pinephone"
fi

# Install megapixels config file
cp /usr/share/megapixels/$DEVICE.ini /etc/megapixels.ini
