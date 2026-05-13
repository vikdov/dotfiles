#!/bin/bash
# Arch Linux System Maintenance Script
# Run with: sudo bash maintenance.sh
# Or add to crontab for automatic execution

set -euo pipefail

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Helper functions
print_header() {
  echo -e "\n${BLUE}=== $1 ===${NC}\n"
}

print_success() {
  echo -e "${GREEN}✓ $1${NC}"
}

print_warning() {
  echo -e "${YELLOW}⚠ $1${NC}"
}

print_error() {
  echo -e "${RED}✗ $1${NC}"
}

# Check if running as root
if [[ $EUID -ne 0 ]]; then
  print_error "This script must be run as root"
  exit 1
fi

print_header "Arch Linux System Maintenance"

# 1. Update system
print_header "1. Updating System Packages"
if pacman -Syu --noconfirm; then
  print_success "System packages updated"
else
  print_error "Failed to update packages"
fi

# 2. Update AUR packages (if using yay or paru)
print_header "2. Updating AUR Packages (Optional)"
if command -v yay &>/dev/null; then
  echo "yay found. Updating AUR packages..."
  sudo -u "$SUDO_USER" yay -Syu --noconfirm || print_warning "AUR update had issues"
  print_success "AUR packages checked"
elif command -v paru &>/dev/null; then
  echo "paru found. Updating AUR packages..."
  sudo -u "$SUDO_USER" paru -Syu --noconfirm || print_warning "AUR update had issues"
  print_success "AUR packages checked"
else
  print_warning "No AUR helper found (yay/paru)"
fi

# 3. Remove orphaned packages
print_header "3. Removing Orphaned Packages"
orphans=$(pacman -Qtdq 2>/dev/null || true)
if [ -z "$orphans" ]; then
  print_success "No orphaned packages found"
else
  count=$(echo "$orphans" | wc -l)
  echo "Found $count orphaned package(s):"
  echo "$orphans"
  echo ""
  read -p "Remove orphaned packages? (y/n) " -n 1 -r
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "$orphans" | pacman -Rns --noconfirm -
    print_success "Orphaned packages removed"
  else
    print_warning "Skipped orphaned package removal"
  fi
fi

# 4. Clean package cache
print_header "4. Cleaning Package Cache"
# Remove leftover partial downloads before cache clean
rm -rf /var/cache/pacman/pkg/download-*
pacman -Sc --noconfirm
print_success "Package cache cleaned (kept latest versions)"

# Optional: aggressive cache cleaning (uncomment to remove all cache)
# pacman -Scc --noconfirm
# print_success "Aggressive cache cleaning done"

# 4.5. Docker cleanup
if command -v docker &>/dev/null && systemctl is-active --quiet docker; then
  print_header "4.5. Docker Cleanup"
  docker system prune -f
  print_success "Docker cleaned"
fi

# 5. Check for configuration file conflicts
print_header "5. Checking Configuration File Conflicts"
conflicts=$(find /etc -name '*.pacnew' -o -name '*.pacsave' 2>/dev/null | wc -l)
if [ "$conflicts" -eq 0 ]; then
  print_success "No configuration conflicts found"
else
  print_warning "$conflicts .pacnew/.pacsave file(s) found"
  find /etc -name '*.pacnew' -o -name '*.pacsave' 2>/dev/null
  echo ""
  if command -v pacdiff &>/dev/null; then
    echo "Review with: pacdiff"
  else
    echo "Review with: find /etc -name '*.pacnew' -o -name '*.pacsave'"
  fi
fi

# 6. Clean old journal logs (keep last 2 weeks)
print_header "6. Cleaning Old System Logs"
journalctl --vacuum-time=2w
print_success "Logs older than 2 weeks removed"

# 7. Check disk usage
print_header "7. Disk Usage Summary"
df -h | grep -E 'Filesystem|/$|/home|/var'
echo ""
disk_usage=$(df / | awk 'NR==2 {print $5}' | sed 's/%//')
if [ "$disk_usage" -gt 80 ]; then
  print_warning "Root partition is over 80% full"
else
  print_success "Disk usage is healthy"
fi

# 8. Check for broken symlinks
print_header "8. Checking for Broken Symlinks"
broken_links=$(find /home /etc /usr /opt -xtype l 2>/dev/null | wc -l)
if [ "$broken_links" -eq 0 ]; then
  print_success "No broken symlinks found"
else
  print_warning "Found $broken_links broken symlinks"
fi

# 9. Verify package integrity
print_header "9. Verifying Package Integrity"
if pacman -Dk 2>&1 | grep -q "warning"; then
  print_warning "Some package integrity issues found"
  pacman -Dk
else
  print_success "All packages integrity verified"
fi

# 10. Summary
print_header "Maintenance Complete"
print_success "System maintenance finished successfully!"
echo ""
echo "Additional maintenance tasks you can run manually:"
echo "  - pacdiff : Review configuration file conflicts"
echo "  - pacman -Dk : Detailed package integrity check"
echo "  - journalctl --disk-usage : Check journal disk usage"
echo "  - systemd-analyze : Analyze boot performance"
