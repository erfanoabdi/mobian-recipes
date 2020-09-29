#!/bin/sh

# Allow non-free components
sed -i '/non-free$/s/# //' /etc/extrepo/config.yaml

# Install the Mobian repo
http_proxy= extrepo enable mobian

# Setup repo priorities so mobian comes first
cat > /etc/apt/preferences.d/00-mobian-priority << EOF
Package: *
Pin: release o=Mobian
Pin-Priority: 700

Package: *
Pin: release o=Debian
Pin-Priority: 500
EOF
