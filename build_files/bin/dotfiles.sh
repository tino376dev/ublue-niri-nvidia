#! /usr/bin/env bash

# Check if a repository URL is supplied
if [ -z "$1" ]; then
  echo "Error: No repository URL supplied." >&2
  echo "Usage: $0 <git-repo-url>" >&2
  exit 1
fi

DOTFILES_DIR="$HOME/dotfiles"

# Clone only if not already present
if [ ! -d "$DOTFILES_DIR" ]; then
    echo "Cloning dotfiles from $1..."
    git clone --bare "$1" "$DOTFILES_DIR"
else
    echo "Dotfiles directory already exists at $DOTFILES_DIR. Skipping clone."
fi

# Define alias for the current shell session
function dot {
   git --git-dir="$DOTFILES_DIR/" --work-tree="$HOME" "$@"
}

echo "Checking out dotfiles..."

# Force checkout, overwriting existing files
dot checkout -f

dot config --local status.showUntrackedFiles no

echo "Dotfiles setup complete."
