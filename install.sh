#!/bin/bash
set -e

echo "=== Arch Linux Config Bootstrap ==="

# Update system
sudo pacman -Syu --noconfirm

# Install stow and git (if not already installed)
sudo pacman -S --noconfirm stow git

# Clone repo if not already in it
if [ ! -d "$HOME/dotfiles" ]; then
  git clone https://github.com/vikdov/dotfiles.git ~/dotfiles
  cd ~/dotfiles
else
  cd ~/dotfiles
  git pull
fi

# Install all packages from list
echo "Installing packages..."
sudo pacman -S --noconfirm $(cat packages.txt)

# Use stow to symlink configs
echo "Stowing dotfiles..."
cd ~/dotfiles
stow --target=$HOME .

echo "=== Setup complete! ==="
