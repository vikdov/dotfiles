#!/bin/bash
set -euo pipefail

DOTFILES_DIR="$HOME/dotfiles"
REPO_URL="https://github.com/vikdov/dotfiles.git"
PACKAGES_DIR="$DOTFILES_DIR/packages/.local/share/recovery-packages"
PACMAN_LIST="$PACKAGES_DIR/pacman_packages.txt"
AUR_LIST="$PACKAGES_DIR/aur_packages.txt"

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
  echo -e "${GREEN}[INFO]${NC} $*"
}

log_warn() {
  echo -e "${YELLOW}[WARN]${NC} $*"
}

log_error() {
  echo -e "${RED}[ERROR]${NC} $*"
}

# Check sudo access
log_info "Checking sudo access..."
if ! sudo -v &>/dev/null; then
  log_error "This script requires sudo access"
  exit 1
fi

echo "=== Arch Linux + Dotfiles Bootstrap ==="
echo

# 1. Update system
log_info "Updating system..."
sudo pacman -Syu --noconfirm

# 2. Install essential tools
log_info "Installing base tools (stow, git, base-devel)..."
sudo pacman -S --needed --noconfirm stow git base-devel

# 3. Install yay if missing
if ! command -v yay &>/dev/null; then
  log_info "Installing yay from AUR..."
  temp_dir=$(mktemp -d)
  trap "rm -rf '$temp_dir'" EXIT

  git clone https://aur.archlinux.org/yay.git "$temp_dir"
  (cd "$temp_dir" && makepkg -si --noconfirm)
else
  log_info "yay already installed."
fi

# 4. Clone or update dotfiles
if [ ! -d "$DOTFILES_DIR" ]; then
  log_info "Cloning dotfiles repository..."
  git clone "$REPO_URL" "$DOTFILES_DIR"
else
  log_info "Updating dotfiles repository..."
  (cd "$DOTFILES_DIR" && git pull --ff-only)
fi

# 5. Install packages — official first, then AUR
if [ -f "$PACMAN_LIST" ]; then
  log_info "Installing official repository packages..."
  sudo pacman -S --needed --noconfirm - <"$PACMAN_LIST" || {
    log_warn "Some official packages failed to install"
  }
else
  log_warn "Package list not found: $PACMAN_LIST"
fi

if [ -f "$AUR_LIST" ]; then
  log_info "Installing AUR packages..."
  yay -S --needed --noconfirm -y - <"$AUR_LIST" || {
    log_warn "Some AUR packages failed to install"
  }
else
  log_warn "AUR package list not found: $AUR_LIST"
fi

# 6. Stow dotfiles (only top-level directories that are stow packages)
log_info "Stowing dotfiles..."
cd "$DOTFILES_DIR"

stow_failures=0

# Stow all direct subdirectories except 'packages' and hidden directories
for dir in */; do
  dir=${dir%/} # Remove trailing slash

  # Skip special directories
  [[ "$dir" == "packages" ]] && continue

  log_info "Stowing $dir..."
  if stow -v --target="$HOME" "$dir"; then
    log_info "✓ Successfully stowed $dir"
  else
    log_error "✗ Failed to stow $dir (exit code: $?)"
    ((stow_failures++))
  fi
done

sudo tee /etc/keyd/default.conf << 'EOF'
[ids]

*

[main]

capslock = overload(control, esc)
esc = capslock
EOF
sudo systemctl enable --now keyd

echo
echo "=== Setup complete! ==="
if [ $stow_failures -eq 0 ]; then
  log_info "All dotfiles stowed successfully."
else
  log_warn "$stow_failures stow operation(s) failed. Review errors above."
fi

echo
log_info "Next steps:"
echo "  1. Review any stow conflicts above"
echo "  2. Restart your shell: exec \$SHELL"
echo "  3. If using Hyprland: log out and back in via tuigreet"
echo
