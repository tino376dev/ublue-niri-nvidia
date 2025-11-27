#!/bin/bash

set -ouex pipefail

### Install packages

# enable copr repos
dnf copr -y enable atim/starship
dnf copr -y enable lihaohong/yazi
dnf copr -y enable scottames/ghostty
dnf copr -y enable yalter/niri

# install
dnf install -y \
  bat \
  brightnessctl \
  du-dust \
  fd-find \
  fish \
  gcc \
  helix \
  git-delta \
  ghostty \
  micro \
  nautilus \
  niri \
  openfortivpn \
  ripgrep \
  sddm \
  starship \
  pavucontrol \
  yazi \
  zoxide

# remove
dnf remove -y firefox

# clean
dnf clean all

# nushell and official plugin binaries
curl -s https://api.github.com/repos/nushell/nushell/releases/latest | grep browser_download_url | grep x86_64-unknown-linux-gnu.tar.gz | cut -d '"' -f 4 | xargs curl -LO
tar -xzf nu-*-x86_64-unknown-linux-gnu.tar.gz
mv nu*/nu* /usr/bin/
rm -rf nu-*-x86_64-unknown-linux-gnu.tar.gz nu-*


# get some extra binaries
assets=$(curl -s https://api.github.com/repos/tino376dev/niri-candy/releases/latest | grep browser_download_url)
curl -sSL $(echo "$assets" | grep awww-linux-amd64.tar.gz | cut -d '"' -f 4) | tar -xz -C /usr/bin
curl -sSL $(echo "$assets" | grep wallpaper.tar.gz | cut -d '"' -f 4) | tar -xz -C /usr/share/backgrounds

# sddm theme
# mkdir /usr/share/sddm/themes/tino376dev
# git clone https://github.com/tino376dev/sddm-theme.git /usr/share/sddm/themes/tino376dev
# rm -rf /usr/share/sddm/themes/tino376dev/.git

# flatpaks
/usr/bin/flatpak remote-add --system --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# podman socket
systemctl enable podman.socket

# display manager
systemctl disable gdm
systemctl enable sddm

# systemd units
cp /ctx/systemd/*.service /usr/lib/systemd/user/

# niri wants
mkdir -p /usr/lib/systemd/user/niri.service.wants
ln -sf /usr/lib/systemd/user/waybar.service /usr/lib/systemd/user/niri.service.wants/waybar.service
ln -sf /usr/lib/systemd/user/mako.service /usr/lib/systemd/user/niri.service.wants/mako.service
ln -sf /usr/lib/systemd/user/swaybg.service /usr/lib/systemd/user/niri.service.wants/swaybg.service
ln -sf /usr/lib/systemd/user/awww-daemon.service /usr/lib/systemd/user/niri.service.wants/awww-daemon.service

# executables
cp /ctx/bin/*.sh /usr/bin/
