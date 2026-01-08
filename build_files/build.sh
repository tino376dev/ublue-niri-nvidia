#!/bin/bash

set -ouex pipefail

### Install packages

# enable copr repos
dnf copr -y enable scottames/awww
dnf copr -y enable ublue-os/packages
dnf copr -y enable yalter/niri

# install
dnf install -y \
  awww \
  brightnessctl \
  foot \
  iwd \
  micro \
  nautilus \
  niri \
  nu \
  openfortivpn \
  podman-compose \
  sddm \
  ublue-brew \
  wiremix

# remove
dnf remove -y firefox

# clean
dnf clean all

# nushell and official plugin binaries
# curl -s https://api.github.com/repos/nushell/nushell/releases/latest | grep browser_download_url | grep x86_64-unknown-linux-gnu.tar.gz | cut -d '"' -f 4 | xargs curl -LO
# tar -xzf nu-*-x86_64-unknown-linux-gnu.tar.gz
# mv nu*/nu* /usr/bin/
# rm -rf nu-*-x86_64-unknown-linux-gnu.tar.gz nu-*

# get some extra binaries/assets
assets=$(curl -s https://api.github.com/repos/tino376dev/niri-candy/releases/latest | grep browser_download_url)
curl -sSL $(echo "$assets" | grep wallpaper.tar.gz | cut -d '"' -f 4) | tar -xz -C /usr/share/backgrounds

assets=$(curl -s https://api.github.com/repos/pythops/bluetui/releases/latest | grep browser_download_url)
curl -sSL $(echo "$assets" | grep bluetui.*x86_64.*linux | cut -d '"' -f 4) -o /usr/bin/bluetui
chmod +x /usr/bin/bluetui

assets=$(curl -s https://api.github.com/repos/pythops/impala/releases/latest | grep browser_download_url)
curl -sSL $(echo "$assets" | grep impala.*x86_64.*linux | cut -d '"' -f 4) -o /usr/bin/impala
chmod +x /usr/bin/impala

# sddm theme
mkdir -p /usr/share/sddm/themes/
cp -r /ctx/sddm/* /usr/share/sddm/themes
ln -sf /usr/share/backgrounds/light-blur.png /usr/share/sddm/themes/light/backgrounds/wall.png
ln -sf /usr/share/backgrounds/dark-blur.png /usr/share/sddm/themes/dark/backgrounds/wall.png

# flatpaks
/usr/bin/flatpak remote-add --system --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo


# iwd config
mkdir -p /etc/NetworkManager/conf.d/
cp /ctx/etc/NetworkManager/conf.d/20-iwd.conf /etc/NetworkManager/conf.d/20-iwd.conf
# cp /ctx/etc/iwd/main.conf /etc/iwd/main.conf
systemctl disable --now wpa_supplicant
restorecon -R /etc/NetworkManager

# podman socket
systemctl enable podman.socket

# display manager
systemctl disable gdm
systemctl enable sddm

# executables
cp /ctx/bin/*.sh /usr/bin/

# just + brew
mkdir -p /usr/share/ublue-os/just
cp /ctx/just/*.just /usr/share/ublue-os/just/
cp /ctx/Brewfile /usr/share/ublue-os/

# systemd units
cp /ctx/systemd/*.service /usr/lib/systemd/user/

# niri wants
mkdir -p /usr/lib/systemd/user/niri.service.wants
ln -sf /usr/lib/systemd/user/waybar.service /usr/lib/systemd/user/niri.service.wants/waybar.service
ln -sf /usr/lib/systemd/user/mako.service /usr/lib/systemd/user/niri.service.wants/mako.service
ln -sf /usr/lib/systemd/user/swaybg.service /usr/lib/systemd/user/niri.service.wants/swaybg.service
ln -sf /usr/lib/systemd/user/awww-daemon.service /usr/lib/systemd/user/niri.service.wants/awww-daemon.service

dnf copr -y remove scottames/awww
dnf copr -y remove ublue-os/packages
dnf copr -y remove yalter/niri
