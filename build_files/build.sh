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
  starship \
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
assets=$(curl -s https://api.github.com/repos/tino376dev/niri-extra-binaries/releases/latest | grep browser_download_url)
echo "$assets" | grep awww-linux-amd64 | cut -d '"' -f 4 | xargs curl -Lo /usr/bin/awww
echo "$assets" | grep awww-daemon-linux-amd64 | cut -d '"' -f 4 | xargs curl -Lo /usr/bin/awww-daemon
echo "$assets" | grep light.png | cut -d '"' -f 4 | xargs curl -Lo /usr/share/backgrounds/light.png
echo "$assets" | grep light-blur.png | cut -d '"' -f 4 | xargs curl -Lo /usr/share/backgrounds/light-blur.png
echo "$assets" | grep dark.png | cut -d '"' -f 4 | xargs curl -Lo /usr/share/backgrounds/dark.png
echo "$assets" | grep dark-blur.png | cut -d '"' -f 4 | xargs curl -Lo /usr/share/backgrounds/dark-blur.png
chmod +x /usr/bin/awww /usr/bin/awww-daemon

# sddm theme
# mkdir /usr/share/sddm/themes/tino376dev
# git clone https://github.com/tino376dev/sddm-theme.git /usr/share/sddm/themes/tino376dev
# rm -rf /usr/share/sddm/themes/tino376dev/.git

# flatpaks
/usr/bin/flatpak remote-add --system --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# podman socket
systemctl enable podman.socket
