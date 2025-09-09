#!/bin/bash

set -ouex pipefail

### Install packages

# enable niri copr
dnf copr -y enable yalter/niri

# install
dnf install -y gcc micro nautilus niri openfortivpn

# remove
dnf remove -y firefox

# clean
dnf clean all

# disable sway as session option
# mv /usr/share/wayland-sessions/sway.desktop /usr/share/wayland-sessions/sway.desktop.disabled

# flatpaks
/usr/bin/flatpak remote-add --system --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# podman socket
systemctl enable podman.socket
