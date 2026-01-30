# AGENTS.md

This file provides guidance to AI coding assistants when working with code in this repository.

## Overview

This is a nix-darwin configuration repository for managing a macOS system declaratively using Nix. It uses nix-darwin for system configuration and Home Manager for user environment configuration, pinned to the 24.11 release.

## Commands

**Apply configuration changes:**
```bash
darwin-rebuild switch
```

**Reload AeroSpace config:**
```bash
aerospace reload-config
```

**Format Nix files:**
```bash
alejandra .
```

**Check flake validity:**
```bash
nix flake check
```

## After Making Changes

- **Always** run `darwin-rebuild switch` after updating any nix configuration files
- **Always** run `aerospace reload-config` after updating `home/aerospace/aerospace.toml`

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
- `aerospace/aerospace.toml` - AeroSpace tiling window manager configuration
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

### AeroSpace Window Manager

**Keybinding style**: i3-style with vim navigation (alt+h/j/k/l for focus)

**Workspaces**:
- Numbers 1-10: General purpose workspaces
- Letters with mnemonic names:
  - A: Hidden workspace for floating bars (Amie)
  - B: Browser (Safari, Chrome, Firefox, Arc, Brave)
  - C: Chat (WhatsApp, Discord, Slack, WeChat, Telegram, Messages)
  - D: Design (Figma, Sketch, Affinity Designer)
  - G: Games (Steam)
  - I: IDE (VS Code, Cursor, IntelliJ, Xcode)
  - M: Music/Media (Spotify, Apple Music, VLC)
  - O: Office (Microsoft Office, iWork apps)
  - P: Passwords (1Password, Bitwarden)
  - R: Reading (Kindle, Books, Preview)
  - T: Terminal (iTerm, Terminal, Warp, Alacritty)
  - U: Utilities (Alfred, Raycast)
  - V: Video (Zoom, FaceTime, OBS)
  - W: Writing (iA Writer, Ulysses)
  - Y: Misc

**Window rules**:
- System apps float by default: Finder, System Settings, Calculator, Activity Monitor, Disk Utility, Reminders, Notes
- Amie floating bar (empty title window) moves to workspace A to prevent focus interference

**Reserved letters** (not used for workspaces):
- H, J, K, L: vim navigation
- N: conflicts with alt+n for ñ

**Known limitations**:
- Cannot hide specific workspaces from menu bar (would need SketchyBar)
- Cannot fully exclude windows from management (feature pending: sticky floating windows)
- Special characters like `grave` not supported in keybindings

### Login Items (Manual Configuration)

These apps are configured to "Open at Login" via System Settings (cannot be managed by nix-darwin):
- Raycast
- Amie
- AeroSpace
- Bitwarden
- Claude

To configure: System Settings → General → Login Items → add apps under "Open at Login"

### Ollama Service (Homebrew Managed)

Ollama runs as a Homebrew service with custom environment variables:
- `OLLAMA_FLASH_ATTENTION=1` - Enable flash attention
- `OLLAMA_KV_CACHE_TYPE=q8_0` - KV cache quantization

LaunchAgent: `~/Library/LaunchAgents/homebrew.mxcl.ollama.plist`

Commands:
```bash
brew services start ollama   # Start the service
brew services stop ollama    # Stop the service
brew services restart ollama # Restart after config changes
```

To modify environment variables, edit the plist directly or use:
```bash
launchctl setenv OLLAMA_FLASH_ATTENTION 1
```
