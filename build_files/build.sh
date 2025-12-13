#!/bin/bash

set -ouex pipefail

### Install packages

# enable copr repos
dnf copr -y enable atim/starship
dnf copr -y enable atim/nushell
dnf copr -y enable lihaohong/yazi
dnf copr -y enable scottames/awww
dnf copr -y enable scottames/ghostty
dnf copr -y enable yalter/niri

# remove
dnf remove -y firefox


# install
dnf install -y \
  awww \
  bat \
  brightnessctl \
  @cosmic-desktop \
  du-dust \
  fd-find \
  fish \
  helix \
  git-delta \
  ghostty \
  micro \
  nautilus \
  niri \
  nushell \
  openfortivpn \
  ripgrep \
  starship \
  pavucontrol \
  yazi \
  zoxide

# clean
dnf clean all
rm -rf /var/lib/dnf

# get some extra binaries
assets=$(curl -s https://api.github.com/repos/tino376dev/niri-candy/releases/latest | grep browser_download_url)
curl -sSL $(echo "$assets" | grep wallpaper.tar.gz | cut -d '"' -f 4) | tar -xz -C /usr/share/backgrounds

# podman socket
systemctl enable podman.socket

# display manager
systemctl enable cosmic-greeter

# systemd units
cp /ctx/systemd/*.service /usr/lib/systemd/user/

# niri wants
mkdir -p /usr/lib/systemd/user/niri.service.wants
ln -sf /usr/lib/systemd/user/waybar.service /usr/lib/systemd/user/niri.service.wants/waybar.service
ln -sf /usr/lib/systemd/user/mako.service /usr/lib/systemd/user/niri.service.wants/mako.service
ln -sf /usr/lib/systemd/user/swaybg.service /usr/lib/systemd/user/niri.service.wants/swaybg.service
ln -sf /usr/lib/systemd/user/awww-daemon.service /usr/lib/systemd/user/niri.service.wants/awww-daemon.service

curl -o /usr/share/bin/start-cosmic-ext-niri https://github.com/Drakulix/cosmic-ext-extra-sessions/blob/main/niri/start-cosmic-ext-niri
chmod +x /usr/share/bin/start-cosmic-ext-niri
curl -o /usr/share/wayland-sessions/cosmic-ext-niri.desktop https://github.com/Drakulix/cosmic-ext-extra-sessions/blob/main/niri/cosmic-ext-niri.desktop

# executables
cp /ctx/bin/*.sh /usr/bin/
