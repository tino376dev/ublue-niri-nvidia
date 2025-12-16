# Sync homebrew packages from the Brewfile
brew-sync:
    echo 'Syncing homebrew packages...'
    brew bundle --file=/usr/share/ublue-os/Brewfile
