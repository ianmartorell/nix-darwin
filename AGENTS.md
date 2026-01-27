# AGENTS.md

This file provides guidance to AI coding assistants when working with code in this repository.

## Overview

This is a nix-darwin configuration repository for managing a macOS system declaratively using Nix. It uses nix-darwin for system configuration and Home Manager for user environment configuration, pinned to the 24.11 release.

## Commands

**Apply configuration changes:**
```bash
darwin-rebuild switch --flake .
```

**Format Nix files:**
```bash
alejandra .
```

**Check flake validity:**
```bash
nix flake check
```

## Architecture

### Flake Structure

The `flake.nix` defines:
- User configuration variables: `username`, `useremail`, `system`, `hostname`
- Uses Determinate Systems Nix installer (hence `nix.enable = false` in nix-core.nix)
- Formatter: alejandra

### Module Organization

**System modules (`modules/`):**
- `nix-core.nix` - Nix daemon settings, unfree packages
- `system.nix` - macOS system defaults (dock, finder, trackpad, keyboard, fonts)
- `apps.nix` - System packages (nix) and Homebrew management (brews, casks)
- `host-users.nix` - Hostname and user account configuration

**Home modules (`home/`):**
- `default.nix` - Imports all home modules, sets Home Manager state version
- `core.nix` - CLI tools, neovim, eza, yazi, direnv
- `shell.nix` - Zsh configuration, PATH setup, shell aliases
- `git.nix` - Git config with delta for diffs, conditional includes for work repos
- `gh.nix` - GitHub CLI configuration
- `ssh.nix` - SSH client configuration with control master
- `starship.nix` - Prompt customization
- `karabiner.nix` - Keyboard remapping (caps lock → escape)
- `aerospace.nix` - Window manager config (symlinks TOML file)
- `nvim.nix` - Neovim config (symlinks kickstart.nvim-based setup)

### Package Management Strategy

- **Nix packages**: Core dev tools, CLI utilities, fonts
- **Homebrew brews**: Tools that work better via Homebrew on macOS (curl, wget, gh)
- **Homebrew casks**: GUI applications
- Homebrew cleanup is set to `uninstall` - unlisted packages get removed on rebuild

### Configuration Patterns

- External config files (aerospace TOML, nvim lua) are symlinked via `xdg.configFile`
- Shell aliases defined in `home/shell.nix` include git shortcuts (gs, gd, gc, etc.)
- Git uses conditional includes for work-specific config at `~/Code/rapidand/`
