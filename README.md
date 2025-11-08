# Dotfiles

My personal dotfiles configuration for Arch Linux, managed with GNU Stow.

## Overview

This repository contains my configuration files (dotfiles) for various applications and tools on Arch Linux. I use GNU Stow to symlink these configurations into their proper locations, making it easy to manage and version control all my settings in one place.

## Prerequisites

Before getting started, make sure you have:

- Arch Linux (or Arch-based distribution)
- Git
- GNU Stow (`pacman -S stow`)

## Installation

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
├── bash/          # Bash configuration
├── nvim/          # Neovim configuration
├── git/           # Git configuration
├── zsh/           # Zsh configuration
├── ...
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

1. Make changes to the configuration files in the `~/.dotfiles` directory
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

- `stow <package>` — Create symlinks for a package
- `stow -D <package>` — Delete symlinks for a package
- `stow -R <package>` — Restow a package (useful after making changes)
- `stow --adopt <package>` — Adopt existing config files into stow

## Notes

- Be careful when using `--adopt` as it will move existing files into the dotfiles directory
- Always back up your current configurations before stowing packages
- Test stow commands with `--simulate` flag first to see what changes will be made

## License

This project is licensed under the MIT License - see the LICENSE file for details.
