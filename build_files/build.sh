#!/bin/bash

set -ouex pipefail

### Install packages

# enable copr repos
dnf copr -y enable yalter/niri
dnf copr -y enable atim/starship

# install
dnf install -y bat du-dust fd-find fish gcc helix micro nautilus niri nu openfortivpn ripgrep starship zoxide

# remove
dnf remove -y firefox

# clean
dnf clean all

# sddm theme
mkdir /usr/share/sddm/themes/tino376dev
git clone https://github.com/tino376dev/sddm-theme.git /usr/share/sddm/themes/tino376dev
rm -rf /usr/share/sddm/themes/tino376dev/.git

# flatpaks
/usr/bin/flatpak remote-add --system --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# podman socket
systemctl enable podman.socket
