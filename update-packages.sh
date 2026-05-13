#!/bin/bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
PACKAGES_DIR="$DOTFILES_DIR/packages/.local/share/recovery-packages"

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BOLD='\033[1m'
NC='\033[0m'

if ! command -v fzf &>/dev/null; then
  echo "fzf required: pacman -S fzf"
  exit 1
fi

tmp_pacman=$(mktemp)
tmp_aur=$(mktemp)
out_pacman=$(mktemp)
out_aur=$(mktemp)
trap "rm -f '$tmp_pacman' '$tmp_aur' '$out_pacman' '$out_aur'" EXIT

pacman -Qqen > "$tmp_pacman"
pacman -Qqem > "$tmp_aur"

select_changes() {
  local label="$1" old="$2" new="$3" outfile="$4"

  local unchanged added removed
  unchanged=$(comm -12 <(sort "$old") <(sort "$new") || true)
  added=$(comm -13 <(sort "$old") <(sort "$new") || true)
  removed=$(comm -23 <(sort "$old") <(sort "$new") || true)

  local tmp_add tmp_keep
  tmp_add=$(mktemp)
  tmp_keep=$(mktemp)

  if [[ -n "$added" ]]; then
    echo "$added" | fzf --multi \
      --prompt="$label  ADD > " \
      --header="TAB=select | Enter=confirm TAB-selected | Ctrl-C=add nothing" \
      --color="pointer:green,marker:green" \
      > "$tmp_add" || true
  fi

  if [[ -n "$removed" ]]; then
    echo "$removed" | fzf --multi \
      --prompt="$label  KEEP > " \
      --header="TAB=toggle remove | Enter=confirm | Ctrl-C=remove ALL" \
      --color="pointer:red,marker:red" \
      --bind "start:select-all" \
      > "$tmp_keep" || true
  fi

  {
    if [[ -n "$unchanged" ]]; then echo "$unchanged"; fi
    if [[ -s "$tmp_add" ]];   then cat "$tmp_add";   fi
    if [[ -s "$tmp_keep" ]];  then cat "$tmp_keep";  fi
  } | sort -u > "$outfile"

  rm -f "$tmp_add" "$tmp_keep"
}

echo "=== Package List Update ==="
echo ""

select_changes "pacman" "$PACKAGES_DIR/pacman_packages.txt" "$tmp_pacman" "$out_pacman"
select_changes "AUR"    "$PACKAGES_DIR/aur_packages.txt"    "$tmp_aur"    "$out_aur"

added_p=$(comm -13 <(sort "$PACKAGES_DIR/pacman_packages.txt") <(sort "$out_pacman") || true)
removed_p=$(comm -23 <(sort "$PACKAGES_DIR/pacman_packages.txt") <(sort "$out_pacman") || true)
added_a=$(comm -13 <(sort "$PACKAGES_DIR/aur_packages.txt") <(sort "$out_aur") || true)
removed_a=$(comm -23 <(sort "$PACKAGES_DIR/aur_packages.txt") <(sort "$out_aur") || true)

if [[ -z "$added_p$removed_p$added_a$removed_a" ]]; then
  echo -e "${YELLOW}No changes selected.${NC}"
  exit 0
fi

echo -e "${BOLD}Summary:${NC}"
if [[ -n "$added_p" ]];   then echo "$added_p"   | while IFS= read -r p; do echo -e "  ${GREEN}+ $p${NC} (pacman)"; done; fi
if [[ -n "$removed_p" ]]; then echo "$removed_p" | while IFS= read -r p; do echo -e "  ${RED}- $p${NC} (pacman)"; done; fi
if [[ -n "$added_a" ]];   then echo "$added_a"   | while IFS= read -r p; do echo -e "  ${GREEN}+ $p${NC} (AUR)"; done; fi
if [[ -n "$removed_a" ]]; then echo "$removed_a" | while IFS= read -r p; do echo -e "  ${RED}- $p${NC} (AUR)"; done; fi

echo ""
read -rp "Save and stage? (y/n) " -n 1 < /dev/tty
echo ""
if [[ ! "$REPLY" =~ ^[Yy]$ ]]; then
  echo "Aborted."
  exit 0
fi

cp "$out_pacman" "$PACKAGES_DIR/pacman_packages.txt"
cp "$out_aur"    "$PACKAGES_DIR/aur_packages.txt"

cd "$DOTFILES_DIR"
git add packages/
echo -e "${GREEN}✓${NC} Staged"
