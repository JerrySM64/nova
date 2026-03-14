#!/bin/bash
set -ouex pipefail

dnf5 -y copr enable yalter/niri
dnf5 -y copr enable zhangyi6324/noctalia-shell
dnf5 -y copr enable peterwu/rendezvous
dnf5 -y copr enable solopasha/hyprland
dnf5 -y copr enable ublue-os/akmods

dnf5 -y install \
    https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
    https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

dnf5 -y install --nogpgcheck \
    --repofrompath 'terra,https://repos.fyralabs.com/terra$releasever' \
    terra-release
dnf5 -y install terra-release-mesa

dnf5 -y remove mesa-va-drivers || true
for pkg in $(rpm -qa --queryformat='%{NAME}\n' | grep -E '^mesa-' | sort -u); do
    dnf5 -y swap --from-repo=terra-mesa "$pkg" "$pkg" || true
done
dnf5 -y install \
    libva-utils \
    vulkan-loader \
    vulkan-tools

dnf5 -y install \
    akmod-nvidia-open \
    xorg-x11-drv-nvidia \
    xorg-x11-drv-nvidia-cuda \
    nvidia-vaapi-driver \
    nvidia-gpu-firmware

dnf5 -y install \
    niri \
    noctalia-shell \
    sddm \
    sddm-wayland-generic \
    bibata-cursor-themes

dnf5 -y install \
    kitty \
    swayidle \
    mate-polkit \
    xdg-user-dirs \
    xwayland-satellite \
    pavucontrol \
    pamixer \
    brightnessctl \
    kcalc \
    playerctl \
    grim \
    slurp

dnf5 -y install swww || echo "WARN: swww not found — skipping"
dnf5 -y install wayfreeze || echo "WARN: wayfreeze not found — skipping"

dnf5 -y install \
    dbus \
    dconf \
    pipewire \
    wireplumber \
    pipewire-pulseaudio \
    xdg-desktop-portal \
    xdg-desktop-portal-gtk \
    xdg-desktop-portal-gnome

dnf5 -y install \
    thunar \
    thunar-volman \
    thunar-archive-plugin \
    thunar-media-tags-plugin \
    tumbler \
    gvfs \
    gvfs-smb \
    gvfs-mtp \
    gvfs-gphoto2 \
    gvfs-afc \
    file-roller

dnf5 -y install firefox

dnf5 -y install \
    qemu-kvm \
    libvirt \
    virt-manager \
    virt-viewer \
    virt-install \
    edk2-ovmf \
    swtpm \
    swtpm-tools \
    libvirt-daemon-driver-qemu \
    libvirt-daemon-driver-network \
    libvirt-daemon-driver-storage

dnf5 -y install flatpak

dnf5 -y install \
    zsh \
    eza \
    bat \
    pacman \
    cups

dnf5 -y install \
    rust \
    cargo \
    java-21-openjdk

dnf5 -y install \
    neovim \
    git \
    make \
    gcc \
    ripgrep \
    fd-find \
    nodejs \
    npm \
    wl-clipboard \
    python3-neovim

cat > /usr/lib/sysusers.d/sddm.conf << 'SYSUSERS'
g sddm - -
u sddm - "SDDM Display Manager" /var/lib/sddm /usr/bin/nologin
SYSUSERS

if [ -d /usr/share/sddm/themes ]; then
    mv /usr/share/sddm/themes /usr/share/sddm/themes.default
else
    mkdir -p /usr/share/sddm/themes.default
fi
ln -sf /var/sddm/themes /usr/share/sddm/themes

mkdir -p /etc/sddm.conf.d
ln -sf /var/sddm/sddm.conf /etc/sddm.conf

cat > /usr/lib/tmpfiles.d/nova-sddm.conf << 'TMPFILES'
C /var/sddm/themes - - - - /usr/share/sddm/themes.default
d /var/sddm 0755 sddm sddm -
f /var/sddm/sddm.conf 0644 root root -
TMPFILES

sed -i \
    -e 's/^NAME=.*/NAME="Nova"/' \
    -e 's/^PRETTY_NAME=.*/PRETTY_NAME="Nova"/' \
    -e 's/^ID=.*/ID=nova/' \
    -e 's/^ID_LIKE=.*/ID_LIKE="fedora"/' \
    /usr/lib/os-release

grep -q '^HOME_URL=' /usr/lib/os-release || echo 'HOME_URL="https://github.com/JerrySM64/nova"' >> /usr/lib/os-release

systemctl enable sddm.service
systemctl enable cups.service
systemctl enable libvirtd.service
systemctl enable podman.socket

dnf5 -y copr disable yalter/niri
dnf5 -y copr disable zhangyi6324/noctalia-shell
dnf5 -y copr disable peterwu/rendezvous
dnf5 -y copr disable solopasha/hyprland
dnf5 -y copr disable ublue-os/akmods
dnf5 -y remove rpmfusion-free-release rpmfusion-nonfree-release terra-release terra-release-mesa || true
dnf5 clean all
