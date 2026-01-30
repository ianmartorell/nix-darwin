# nix-darwin Configuration

Declarative macOS system configuration using [nix-darwin](https://github.com/LnL7/nix-darwin) and [Home Manager](https://github.com/nix-community/home-manager), pinned to the 24.11 release.

## Quick Start

### Prerequisites

- macOS on Apple Silicon (aarch64-darwin)
- [Determinate Systems Nix Installer](https://github.com/DeterminateSystems/nix-installer)

### Apply Configuration

```bash
darwin-rebuild switch
```

### After Making Changes

- Run `darwin-rebuild switch` after updating any `.nix` files
- Run `aerospace reload-config` after updating `home/aerospace/aerospace.toml`

## Directory Structure

```
.
├── flake.nix              # Entry point, defines inputs and system config
├── flake.lock             # Locked dependency versions
│
├── modules/               # System-level configuration
│   ├── system.nix         # Core system settings, timezone, shell
│   ├── defaults.nix       # macOS system defaults (dock, finder, etc.)
│   ├── fonts.nix          # Font packages
│   ├── security.nix       # TouchID sudo, security settings
│   ├── apps.nix           # Nix packages and Homebrew management
│   ├── nix-core.nix       # Nix daemon settings
│   └── host-users.nix     # Hostname and user configuration
│
└── home/                  # User configuration (Home Manager)
    ├── default.nix        # Imports all home modules
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

| Source | Use Case |
|--------|----------|
| **Nix packages** | Core CLI tools, fonts, reproducible builds |
| **Homebrew brews** | Tools that work better via Homebrew on macOS |
| **Homebrew casks** | GUI applications |

Homebrew cleanup is set to `uninstall` - unlisted packages get removed on rebuild.

## Key Features

- **Declarative macOS defaults**: Dock, Finder, trackpad, keyboard settings
- **AeroSpace**: i3-style tiling window manager with vim navigation
- **Karabiner**: Caps Lock → Escape remapping
- **Development tools**: Neovim, Zed, git with delta, lazygit
- **Shell**: Zsh with vi-mode, starship prompt, eza, yazi

## Customization

1. Edit user variables in `flake.nix`:
   ```nix
   username = "ian";
   useremail = "ianmartorell@gmail.com";
   hostname = "mbp";
   ```

2. Modify packages in `modules/apps.nix` (Homebrew) or `home/core.nix` (Nix)

3. Adjust macOS defaults in `modules/defaults.nix`

## Documentation

- [nix-darwin Manual](https://daiderd.com/nix-darwin/manual/index.html)
- [Home Manager Manual](https://nix-community.github.io/home-manager/)
- [Nixpkgs Search](https://search.nixos.org/packages)
- [AGENTS.md](./AGENTS.md) - Detailed documentation for AI assistants
