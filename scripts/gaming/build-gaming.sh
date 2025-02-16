#!/usr/bin/env bash

set -ouex pipefail

dnf5 -y config-manager addrepo --from-repofile=https://negativo17.org/repos/fedora-steam.repo


# Steam
dnf5 -y --setopt=install_weak_deps=False install steam lutris