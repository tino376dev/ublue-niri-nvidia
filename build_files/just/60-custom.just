# Sync homebrew packages from the Brewfile
brew-sync:
    echo 'Syncing homebrew packages...'
    brew bundle --file=/usr/share/ublue-os/Brewfile

# Setup Google container (usage: just google [install|update])
google action="install":
    @/usr/bin/setup-google-container.sh {{action}}

# Setup Microsoft container (usage: just microsoft [install|update])
microsoft action="install":
    @/usr/bin/setup-microsoft-container.sh {{action}}
