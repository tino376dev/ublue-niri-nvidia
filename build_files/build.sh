#!/bin/bash

set -ouex pipefail

### Install packages

# enable niri copr
dnf copr -y enable yalter/niri

# install
dnf install -y gcc micro nautilus niri nu openfortivpn

# remove
dnf remove -y firefox

# clean
dnf clean all

# sddm theme
nu -c 'http get https://api.github.com/repos/catppuccin/sddm/releases/latest | get $.assets.browser_download_url | where ($it | str ends-with "catppuccin-mocha-lavender-sddm.zip") | get 0 | http get $in | save -r "catppuccin.zip"'
unzip -o catppuccin.zip -d /usr/share/sddm/themes
rm catppuccin.zip
curl -o /usr/share/wallpapers/cosmic.jpg https://raw.githubusercontent.com/tino376dev/dofiles/.config/wallpapers/cosmic.jpg
curl -o /usr/share/wallpapers/cosmic-blur.jpg https://raw.githubusercontent.com/tino376dev/dofiles/.config/wallpapers/cosmic-blur.jpg
# disable sway as session option
# mv /usr/share/wayland-sessions/sway.desktop /usr/share/wayland-sessions/sway.desktop.disabled

# flatpaks
/usr/bin/flatpak remote-add --system --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# podman socket
systemctl enable podman.socket
