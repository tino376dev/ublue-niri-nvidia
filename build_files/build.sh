#!/bin/bash

set -ouex pipefail

### Install packages

# enable copr repos
dnf copr -y enable yalter/niri
dnf copr -y enable atim/starship

# install
dnf install -y bat fd-find fish gcc helix micro nautilus niri nu openfortivpn ripgrep starship zoxide

# remove
dnf remove -y firefox

# clean
dnf clean all

# sddm theme
nu -c 'http get https://api.github.com/repos/catppuccin/sddm/releases/latest | get $.assets.browser_download_url | where ($it | str ends-with "catppuccin-mocha-lavender-sddm.zip") | get 0 | http get $in | save -r "catppuccin.zip"'
unzip -o catppuccin.zip -d /usr/share/sddm/themes
rm catppuccin.zip
nu -c 'http get https://raw.github.com/tino376dev/files/main/cosmic-blur.png | save -rf /usr/share/sddm/themes/catppuccin-mocha-lavender/backgrounds/wall.png'
nu -c 'open -r /usr/share/sddm/themes/catppuccin-mocha-lavender/theme.conf | str replace ''UserIcon="false"'' ''UserIcon="true"'' | save -rf /usr/share/sddm/themes/catppuccin-mocha-lavender/theme.conf'

# flatpaks
/usr/bin/flatpak remote-add --system --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# podman socket
systemctl enable podman.socket
