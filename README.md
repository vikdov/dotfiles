# Dotfiles

My personal dotfiles configuration for Arch Linux, managed with GNU Stow.

## Overview

This repository contains my configuration files (dotfiles) for various applications and tools on Arch Linux. I use GNU Stow to symlink these configurations into their proper locations, making it easy to manage and version control all my settings in one place.

## Quick Start

For a complete system recovery or fresh installation, download and run the bootstrap script:

```bash
curl -LO https://raw.githubusercontent.com/vikdov/dotfiles/main/bootstrap.sh
chmod +x bootstrap.sh
./bootstrap.sh
```

The script will:
- Update your system
- Install essential tools (stow, git, base-devel)
- Install AUR helper (yay)
- Clone/update your dotfiles
- Install all packages from your package lists
- Automatically stow all dotfile packages

## Prerequisites

- **Arch Linux** (or Arch-based distribution)
- **curl** — to download the bootstrap script
- **sudo access** — required for system updates and package installation

Manual installation requires **GNU Stow** — `sudo pacman -S stow`

## Manual Installation

If you prefer to set up manually without the bootstrap script:

1. Clone this repository into your home directory:

```bash
git clone https://github.com/vikdov/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

2. Use Stow to create symlinks for the packages you want to install:

```bash
stow <package-name>
```

For example, to install all configurations:

```bash
stow */
```

Or to install specific packages:

```bash
stow bash
stow nvim
stow git
```

3. Verify the symlinks were created correctly:

```bash
ls -la ~/ | grep '^l'
```

## Directory Structure

The repository is organized into packages, each representing a different application or tool:

```
dotfiles/
├── bash/              # Bash configuration
├── nvim/              # Neovim configuration
├── zsh/               # Zsh configuration
├── hyprland/          # Hyprland window manager
├── packages/          # Package lists and recovery data
│   └── .local/share/recovery-packages/
│       ├── pacman_packages.txt    # Official repository packages
│       └── aur_packages.txt       # AUR packages
└── ...
```

Each package mirrors the home directory structure, so files are placed in their correct locations when stowed.

## Managing Dotfiles

### Adding a new package

1. Create a new directory for the application:

```bash
mkdir -p packagename/.config/application
```

2. Move or copy the configuration files into the package directory, maintaining the directory structure relative to home.

3. Stow the package:

```bash
stow packagename
```

### Updating dotfiles

1. Make changes to the configuration files in the `~/dotfiles` directory
2. Commit and push changes to the repository:

```bash
git add .
git commit -m "Update configuration"
git push
```

### Removing a package

To remove symlinks for a package:

```bash
stow -D packagename
```

## Useful Stow Commands

| Command | Description |
|---------|-------------|
| `stow <package>` | Create symlinks for a package |
| `stow -D <package>` | Delete symlinks for a package |
| `stow -R <package>` | Restow a package (useful after changes) |
| `stow --adopt <package>` | Adopt existing config files into stow |
| `stow --simulate <package>` | Preview changes without applying them |

## Tips and Best Practices

- Always back up your current configurations before stowing packages
- Test stow commands with the `--simulate` flag first to see what changes will be made
- Be careful with `--adopt` as it will move existing files into the dotfiles directory
- If you switch to Zsh, use: `chsh -s $(which zsh)`
- If using Hyprland, log out and back in via tuigreet after running the bootstrap script
- Keep your package lists updated: `pacman -Qqe > packages/.local/share/recovery-packages/pacman_packages.txt`
- For AUR packages: `pacman -Qqm > packages/.local/share/recovery-packages/aur_packages.txt`

## Troubleshooting

**Stow conflicts**: If stow fails due to existing files, review the conflicts and either delete the files or use `stow --adopt` to move them into the repository.

**Shell not updating**: After changing your shell with `chsh`, restart your terminal or run `exec $SHELL` to apply changes.

**Bootstrap script fails**: Check the error messages above the summary. Some packages may require manual intervention or may not be available in your Arch version.

## License

This project is licensed under the MIT License - see the LICENSE file for details.
