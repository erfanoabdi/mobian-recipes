#!/bin/sh

# Our proxy is apt-cacher-ng, which can't handle SSL connections
unset http_proxy

# Allow non-free components
sed -i '/non-free$/s/# //' /etc/extrepo/config.yaml

# Install the Mobian repo
extrepo enable mobian

# Setup repo priorities so mobian comes first
cat > /etc/apt/preferences.d/00-mobian-priority << EOF
Package: *
Pin: release o=Mobian
Pin-Priority: 700

Package: *
Pin: release o=Debian
Pin-Priority: 500
EOF
