#!/usr/bin/env bash

action=${1:-install}

if [ "$action" == "install" ]; then
  # Create the distrobox container
  if ! distrobox list | grep -q "google"; then
    distrobox-create \
    --name google \
    --image registry.fedoraproject.org/fedora-toolbox:latest \
    --volume /home/linuxbrew/.linuxbrew:/home/linuxbrew/.linuxbrew:ro,z \
    --yes
  else
    echo "Container 'google' already exists. Proceeding to install packages..."
  fi

  # Install packages inside the container
  distrobox-enter --name google -- bash -c '
  # install google chrome
  sudo dnf -y install fedora-workstation-repositories
  sudo dnf config-manager setopt google-chrome.enabled=1
  sudo dnf -y install google-chrome-stable
  distrobox-export --app google-chrome --export-label none
  # install antigravity ide
  sudo tee /etc/yum.repos.d/antigravity.repo << EOL
[antigravity-rpm]
name=Antigravity RPM Repository
baseurl=https://us-central1-yum.pkg.dev/projects/antigravity-auto-updater-dev/antigravity-rpm
enabled=1
gpgcheck=0
EOL
  sudo dnf makecache
  sudo dnf -y install antigravity
  distrobox-export --app antigravity --export-label none
  '

elif [ "$action" == "update" ]; then
  if distrobox list | grep -q "google"; then
    echo "Updating 'google' container..."
    distrobox-enter --name google -- sudo dnf update -y
  else
    echo "Container 'google' does not exist. Please run install first."
    exit 1
  fi
else
  echo "Usage: $0 [install|update]"
  exit 1
fi
