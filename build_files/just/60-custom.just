# Sync homebrew packages from the Brewfile
brew-sync:
    echo 'Syncing homebrew packages...'
    brew bundle --file=/usr/share/ublue-os/Brewfile

# Setup Google container (usage: just setup-google [install|update])
setup-google action="install":
    @/usr/bin/setup-google-container.sh {{action}}

# Setup Microsoft container (usage: just setup-microsoft [install|update])
setup-microsoft action="install":
    @/usr/bin/setup-microsoft-container.sh {{action}}
