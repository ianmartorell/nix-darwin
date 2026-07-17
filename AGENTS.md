# AGENTS.md

This file provides guidance to AI coding assistants when working with code in this repository.

## Overview

This is a nix-darwin configuration repository for managing multiple macOS machines declaratively using Nix. It supports two machines (MacBook Pro and Mac Mini) with different configurations and multiple users. Uses nix-darwin for system configuration and Home Manager for user environment configuration, pinned to the 24.11 release.

**Machines:**
- `mbp` - MacBook Pro (full desktop, single user: ian)
- `mini` - Mac Mini (minimal server, two users: ian and jarvis)

**Users:**
- `ian` - Primary user on both machines
- `jarvis` - OpenClaw AI agent (mini only, isolated for security)

## Commands

**Apply configuration changes:**
```bash
sudo darwin-rebuild switch
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

## Documentation Guidelines

**IMPORTANT:** After making changes to the nix-darwin configuration, always check if documentation needs updating:

- **README.md** - Update if you:
  - Add/remove/rename files in `modules/` or `home/`
  - Change the package management strategy
  - Modify the machine configurations
  - Add new features or capabilities

- **AGENTS.md** - Update if you:
  - Change the architecture or module organization
  - Add/remove machines or users
  - Modify configuration patterns or conventions
  - Add new commands or workflows
  - Change the package management approach

- **SETUP.md** - Update if you:
  - Change the initial setup process
  - Add/remove machines or configurations
  - Modify prerequisites or installation steps
  - Change how Homebrew is managed

Always review all three documentation files after structural changes to ensure they accurately reflect the current state of the repository.

## After Making Changes

- **Always** run `sudo darwin-rebuild switch` after updating any nix configuration files
- **Always** run `aerospace reload-config` after updating `home/aerospace/aerospace.toml`
- **Always** check if documentation (README.md, AGENTS.md, SETUP.md) needs updates

## Architecture

### Flake Structure

The `flake.nix` defines:
- User configuration variables: `username`, `fullname`, `useremail`, `system`
- Two machine configurations: `mbp` (MacBook Pro) and `mini` (Mac Mini)
- Uses Determinate Systems Nix installer (hence `nix.enable = false` in nix-core.nix)
- Formatter: alejandra

**Machine configurations:**
- `mbp`: Uses `modules/mbp-apps.nix` + `home/mbp-ian.nix`
- `mini`: Uses `modules/mini-apps.nix` + `home/mini-ian.nix` + `home/mini-jarvis.nix`

### Module Organization

**System modules (`modules/`) - Shared by all users on a machine:**
- `nix-core.nix` - Nix daemon settings, unfree packages
- `system.nix` - Core system settings (imports defaults, fonts, security)
- `defaults.nix` - macOS system defaults (dock, finder, trackpad, keyboard)
- `fonts.nix` - Font packages
- `security.nix` - TouchID sudo, security settings
- `host-users.nix` - Hostname and user account configuration
- `mbp-apps.nix` - MacBook Pro: System packages + system Homebrew
- `mini-apps.nix` - Mac Mini: System packages + system Homebrew (shared services only)

**User config files (`home/`) - Machine-user naming convention:**
- `mbp-ian.nix` - Ian's configuration on MacBook Pro
- `mini-ian.nix` - Ian's configuration on Mac Mini
- `mini-jarvis.nix` - Jarvis's configuration on Mac Mini

**Shared component modules (`home/`) - Imported by user configs:**
- `homebrew.nix` - Per-user Homebrew module (installs to `~/.homebrew`)
- `core.nix` - CLI tools, neovim, eza, yazi, direnv
- `shell.nix` - Zsh configuration, PATH setup, shell aliases, rebuild functions
- `git.nix` - Git config with delta for diffs, conditional includes for work repos
- `gh.nix` - GitHub CLI configuration
- `ssh.nix` - SSH client configuration with control master
- `starship.nix` - Prompt customization
- `karabiner.nix` - Keyboard remapping (caps lock → escape)
- `aerospace.nix` - Window manager config (symlinks TOML file)
- `aerospace/aerospace.toml` - AeroSpace tiling window manager configuration
- `nvim.nix` - Neovim config (symlinks kickstart.nvim-based setup)
- `zed.nix` - Zed editor settings
- `mpv.nix` - mpv player config

### Package Management Strategy

**Nix packages** (all machines):
- Core dev tools, CLI utilities, fonts
- Defined in `modules/{machine}-apps.nix` and `home/core.nix`

**System Homebrew** (mbp only):
- Location: `/opt/homebrew`
- Defined in: `modules/mbp-apps.nix`
- Use for: GUI applications (casks) and system-wide tools (brews)
- Cleanup set to `uninstall` - unlisted packages get removed on rebuild

**System Homebrew** (mini):
- Location: `/opt/homebrew`
- Defined in: `modules/mini-apps.nix`
- Use for: Shared system services only (e.g., tailscale)
- Cleanup set to `uninstall` - unlisted packages get removed on rebuild

**Per-user Homebrew** (mini only):
- Location: `~/.homebrew` (separate installation per user)
- Defined in: `home/mini-{user}.nix` (e.g., `mini-ian.nix`, `mini-jarvis.nix`)
- Use for: User-specific packages to avoid permission conflicts on multi-user systems
- Module: `home/homebrew.nix` provides the per-user installation logic
- Configured via: `homebrew.enable`, `homebrew.packages`, `homebrew.casks`, `homebrew.taps`

**Why both on mini?**
- System Homebrew manages shared services (tailscale, etc.)
- Per-user Homebrew avoids permission conflicts between ian and jarvis for user-specific packages
- Each user can manage their own packages independently

### Configuration Patterns

- External config files (aerospace TOML, nvim lua) are symlinked via `xdg.configFile`
- Shell aliases defined in `home/shell.nix` include:
  - Git shortcuts (gs, gd, gc, etc.)
  - `rebuild` - Pull latest config and rebuild on current machine
  - `rebuild-mini` / `rebuild-mbp` - SSH rebuild functions for remote machines
- Git uses conditional includes for work-specific config at `~/Code/rapidand/`
- File naming convention: `{machine}-{purpose}.nix` or `{machine}-{user}.nix` for clarity

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

**Note:** On mini, system Homebrew is used only for shared services (e.g., tailscale). User-specific packages should use per-user Homebrew installations.
