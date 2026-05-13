#!/bin/bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
issues=0

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}=== Dotfiles Health Check ===${NC}"
echo ""

cd "$DOTFILES_DIR"

echo "Stow packages:"
for dir in */; do
  dir=${dir%/}
  [[ "$dir" == "packages" ]] && continue

  pkg_issues=0
  while IFS= read -r file; do
    rel="${file#"$dir"/}"
    target="$HOME/$rel"
    expected="$DOTFILES_DIR/$file"
    if [[ ! -L "$target" ]] || [[ "$(readlink -f "$target")" != "$(readlink -f "$expected")" ]]; then
      pkg_issues=$((pkg_issues + 1))
    fi
  done < <(find "$dir" -type f)

  if [[ "$pkg_issues" -eq 0 ]]; then
    echo -e "  ${GREEN}✓${NC} $dir"
  else
    echo -e "  ${RED}✗${NC} $dir ($pkg_issues file(s) not stowed)"
    issues=$((issues + 1))
  fi
done

echo ""
echo "Broken symlinks in ~:"
mapfile -t broken < <(find "$HOME" -maxdepth 4 -xtype l 2>/dev/null \
  | grep -v "/.local/share/zinit" \
  | grep -v "/node_modules" \
  | grep -v "/.cargo" \
  | grep -v "/.rustup" \
  || true)

if [[ ${#broken[@]} -eq 0 ]]; then
  echo -e "  ${GREEN}✓${NC} None"
else
  for link in "${broken[@]}"; do
    echo -e "  ${RED}✗${NC} $link"
    issues=$((issues + 1))
  done
fi

echo ""
if [[ "$issues" -eq 0 ]]; then
  echo -e "${GREEN}All healthy.${NC}"
else
  echo -e "${YELLOW}⚠ $issues issue(s) found.${NC}"
  exit 1
fi
