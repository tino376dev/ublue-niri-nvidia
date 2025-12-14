#!/bin/bash

set -ouex pipefail

### Install packages

# enable copr repos
dnf copr -y enable scottames/awww
dnf copr -y enable ublue-os/packages
dnf copr -y enable yalter/niri

# remove
dnf remove -y firefox


# install
dnf install -y \
  @cosmic-desktop \
  awww \
  brightnessctl \
  micro \
  nautilus \
  niri \
  openfortivpn \
  pavucontrol \
  ublue-brew

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

# executables
cp /ctx/bin/*.sh /usr/bin/

# justfiles
mkdir -p /usr/share/ublue-os/just
cp /ctx/just/*.just /usr/share/ublue-os/just/

# brewfile
cp /ctx/Brewfile /usr/share/ublue-os/

curl -o /usr/bin/start-cosmic-ext-niri https://raw.githubusercontent.com/Drakulix/cosmic-ext-extra-sessions/main/niri/start-cosmic-ext-niri
curl -o /usr/share/wayland-sessions/cosmic-ext-niri.desktop https://raw.githubusercontent.com/Drakulix/cosmic-ext-extra-sessions/main/niri/cosmic-niri.desktop
sed -i 's|/usr/local/bin|/usr/bin|g' /usr/share/wayland-sessions/cosmic-ext-niri.desktop
chmod +x /usr/bin/start-cosmic-ext-niri

dnf copr -y remove scottames/awww
dnf copr -y remove ublue-os/packages
dnf copr -y remove yalter/niri

