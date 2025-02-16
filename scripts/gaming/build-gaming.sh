#!/usr/bin/env bash

set -ouex pipefail


dnf5 -y copr enable sentry/kernel-blu
dnf5 -y install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
dnf5 -y config-manager addrepo --from-repofile=https://negativo17.org/repos/fedora-steam.repo


# Steam
dnf5 -y --setopt=install_weak_deps=False install steam lutris