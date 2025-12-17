#!/bin/bash

# Exit on error, undefined variables, and pipe failures
set -euo pipefail

DOTFILES_DIR="$HOME/dotfiles"
REPO_URL="https://github.com/vikdov/dotfiles.git"

echo "=== Arch Linux Config Bootstrap ==="

# 1. Update System
echo "Updating system..."
sudo pacman -Syu --noconfirm

# 2. Install Core Dependencies
echo "Installing base dependencies..."
sudo pacman -S --noconfirm stow git base-devel

# 3. Install yay (AUR Helper)
if ! command -v yay &> /dev/null; then
    echo "yay not found. Installing from AUR..."
    TEMP_DIR=$(mktemp -d)
    git clone https://aur.archlinux.org/yay.git "$TEMP_DIR"
    cd "$TEMP_DIR"
    makepkg -si --noconfirm
    cd - > /dev/null
    rm -rf "$TEMP_DIR"
else
    echo "yay is already installed."
fi

# 4. Clone or Update Dotfiles
if [ ! -d "$DOTFILES_DIR" ]; then
    echo "Cloning dotfiles..."
    git clone "$REPO_URL" "$DOTFILES_DIR"
    cd "$DOTFILES_DIR"
else
    echo "Updating existing dotfiles..."
    cd "$DOTFILES_DIR"
    git pull
fi

# 5. Install Packages
# Using yay handles both official repo and AUR packages from your list
if [ -f "packages.txt" ]; then
    echo "Installing packages from list..."
    # Filter out empty lines or comments if any exist in the file
    grep -vE '^\s*(#|$)' packages.txt | xargs yay -S --noconfirm --needed
else
    echo "Warning: packages.txt not found. Skipping package installation."
fi

# 6. Stow Dotfiles
echo "Stowing dotfiles..."
# Iterate through top-level directories to stow them individually
# This avoids stowing the .git folder or the script itself
for dir in $(find . -maxdepth 1 -type d -not -path '*/.*'); do
    stow -v --target="$HOME" "${dir#./}"
done

echo "=== Setup complete! Please restart your shell. ==="
