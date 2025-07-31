#!/bin/bash

set -ouex pipefail

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/39/x86_64/repoview/index.html&protocol=https&redirect=1

# this installs a package from fedora repos
dnf5 install -y micro nautilus niri openfortivpn
# dnfr uninstall -y sway

# disable sway as session option
mv /usr/share/wayland-sessions/sway.desktop /usr/share/wayland-sessions/sway.desktop.disabled

# set default wallpaper
curl -o /usr/share/backgrounds/default.jxl https://raw.githubusercontent.com/tino376dev/dotfiles/main/.config/wallpaper/cosmic-blur.jpg
sed -i 's/jxl/jpg/g' /usr/share/sddm/themes/03-sway-fedora/theme.conf
# Use a COPR Example:
#
# dnf5 -y copr enable ublue-os/staging
# dnf5 -y install package
# Disable COPRs so they don't end up enabled on the final image:
# dnf5 -y copr disable ublue-os/staging

#### Example for enabling a System Unit File

systemctl enable podman.socket
