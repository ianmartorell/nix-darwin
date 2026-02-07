# nix-darwin Configuration

Declarative macOS system configuration using [nix-darwin](https://github.com/LnL7/nix-darwin) and [Home Manager](https://github.com/nix-community/home-manager), pinned to the 24.11 release.

## Quick Start

### Prerequisites

- macOS on Apple Silicon (aarch64-darwin)
- [Determinate Systems Nix Installer](https://github.com/DeterminateSystems/nix-installer)

### Apply Configuration

```bash
sudo darwin-rebuild switch
```

### After Making Changes

- Run `sudo darwin-rebuild switch` after updating any `.nix` files
- Run `aerospace reload-config` after updating `home/aerospace/aerospace.toml`

## Directory Structure

```
.
├── flake.nix              # Entry point, defines machines (mbp/mini)
├── flake.lock             # Locked dependency versions
│
├── modules/               # System-level configuration (shared by all users)
│   ├── nix-core.nix       # Nix daemon settings
│   ├── system.nix         # Core system settings, timezone, shell
│   ├── defaults.nix       # macOS system defaults (dock, finder, etc.)
│   ├── fonts.nix          # Font packages
│   ├── security.nix       # TouchID sudo, security settings
│   ├── host-users.nix     # Hostname and user configuration
│   ├── mbp-apps.nix       # MacBook Pro: Nix packages + system Homebrew
│   └── mini-apps.nix      # Mac Mini: Nix packages + system Homebrew (shared services)
│
└── home/                  # Per-user configuration (Home Manager)
    ├── mbp-ian.nix        # Ian's config on MacBook Pro
    ├── mini-ian.nix       # Ian's config on Mac Mini
    ├── mini-jarvis.nix    # Jarvis (OpenClaw AI) config on Mac Mini
    │
    ├── homebrew.nix       # Per-user Homebrew module (used by mini)
    ├── core.nix           # CLI tools (ripgrep, jq, fzf, etc.)
    ├── shell.nix          # Zsh configuration
    ├── git.nix            # Git config with delta
    ├── gh.nix             # GitHub CLI
    ├── ssh.nix            # SSH client config
    ├── starship.nix       # Prompt customization
    ├── karabiner.nix      # Keyboard remapping
    ├── aerospace.nix      # Window manager config
    ├── nvim.nix           # Neovim configuration
    ├── zed.nix            # Zed editor settings
    └── mpv.nix            # mpv player config
```

## Package Management

| Source | Use Case | Machines |
|--------|----------|----------|
| **Nix packages** | Core CLI tools, fonts, reproducible builds | All |
| **System Homebrew** | GUI apps and system-wide tools | mbp only |
| **Per-user Homebrew** | User-specific packages at `~/.homebrew` | mini only |

**MacBook Pro (mbp):** Uses system Homebrew at `/opt/homebrew` (single user).

**Mac Mini (mini):** Uses both system and per-user Homebrew:
- System Homebrew at `/opt/homebrew` for shared services (e.g., tailscale)
- Per-user Homebrew to avoid permission conflicts:
  - Ian: `~ian/.homebrew`
  - Jarvis: `~jarvis/.homebrew`

System Homebrew cleanup is set to `uninstall` - unlisted packages get removed on rebuild.

## Key Features

- **Declarative macOS defaults**: Dock, Finder, trackpad, keyboard settings
- **AeroSpace**: i3-style tiling window manager with vim navigation
- **Karabiner**: Caps Lock → Escape remapping
- **Development tools**: Neovim, Zed, git with delta, lazygit
- **Shell**: Zsh with vi-mode, starship prompt, eza, yazi

## Forking This Repo

If you want to use this configuration as a starting point, you'll need to change:

### Required Changes

1. **User variables in `flake.nix`**:
   ```nix
   username = "ian";           # Your macOS username
   fullname = "Ian Martorell"; # Your full name (for git)
   useremail = "ianmartorell@gmail.com";  # Your email (for git)
   ```

2. **Machine configurations in `flake.nix`**:
   - Adjust the `darwinConfigurations` for your machines (mbp/mini)
   - Update hostname references in each machine config

3. **User config files in `home/`**:
   - Rename `mbp-ian.nix` to match your username and machine
   - Update imports in `flake.nix` to reference your renamed files
   - Remove `mini-jarvis.nix` if you don't need multiple users

4. **Karabiner device IDs in `home/karabiner.nix`**:
   - The `vendor_id` and `product_id` are specific to my keyboard
   - Find yours in Karabiner-EventViewer.app → Devices tab
   - Or remove the `devices` block to apply rules to all keyboards

### Optional Changes

5. **Work-specific git config in `home/git.nix`**:
   - Remove or modify the `includes` block for work repos

6. **Packages in `modules/mbp-apps.nix` or `modules/mini-apps.nix`** - Add/remove system packages

7. **Per-user Homebrew packages** in your user config files (e.g., `mini-ian.nix`)

8. **CLI tools in `home/core.nix`** - Add/remove Nix packages

9. **macOS defaults in `modules/defaults.nix`** - Adjust system preferences

## Documentation

- [nix-darwin Manual](https://daiderd.com/nix-darwin/manual/index.html)
- [Home Manager Manual](https://nix-community.github.io/home-manager/)
- [Nixpkgs Search](https://search.nixos.org/packages)
- [AGENTS.md](./AGENTS.md) - Detailed documentation for AI assistants
