#!/bin/bash

set -ouex pipefail

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/39/x86_64/repoview/index.html&protocol=https&redirect=1

# this installs the COSMIC desktop
dnf5 install -y cosmic-app-library cosmic-applets cosmic-bg cosmic-comp cosmic-edit cosmic-files cosmic-greeter cosmic-icon-theme cosmic-launcher cosmic-notifications cosmic-osd cosmic-panel cosmic-randr cosmic-screenshot cosmic-session cosmic-settings cosmic-settings-daemon cosmic-store cosmic-term cosmic-workspaces xdg-desktop-portal-cosmic


systemctl disable systemd-remount-fs.service
# systemctl enable podman.socket
# systemctl enable libvirtd.service
# systemctl enable tailscaled.service
