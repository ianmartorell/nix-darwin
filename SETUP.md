# Setting Up a New Mac with nix-darwin

This guide documents how to set up nix-darwin on a fresh macOS installation, based on real-world experience.

## Prerequisites

- A fresh macOS installation (Apple Silicon)
- Admin access (sudo)
- GitHub account with access to this repository

## Step 1: Install Nix

Use the Determinate Systems **native macOS package** (not the shell installer, which can fail with APFS volume issues):

```bash
curl -L https://install.determinate.systems/determinate-pkg/stable/Universal -o /tmp/nix.pkg
sudo installer -pkg /tmp/nix.pkg -target /
```

After installation, start a new terminal session to get Nix in your PATH.

Verify it works:
```bash
nix --version
```

## Step 2: Install Homebrew

nix-darwin can manage Homebrew packages, but Homebrew itself must be installed separately first:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

On Apple Silicon, add Homebrew to your PATH:
```bash
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"
```

## Step 3: Set Up SSH Key for GitHub

Generate an SSH key:
```bash
ssh-keygen -t ed25519 -C "your-email@example.com" -f ~/.ssh/id_ed25519 -N ""
```

Display the public key:
```bash
cat ~/.ssh/id_ed25519.pub
```

Add the key to GitHub:
- Go to https://github.com/settings/keys
- Click "New SSH key"
- Paste the public key

Or if you have `gh` CLI on another machine:
```bash
gh ssh-key add - --title "Machine Name" <<< "ssh-ed25519 AAAA..."
```

## Step 4: Clone the Configuration

Create the directory and clone:
```bash
sudo mkdir -p /etc/nix-darwin
sudo chown $(whoami):staff /etc/nix-darwin
```

Use Nix's git (no need to install Xcode Command Line Tools):
```bash
nix run nixpkgs#git -- clone git@github.com:ianmartorell/nix-darwin.git /etc/nix-darwin
```

## Step 5: Bootstrap nix-darwin

Run the initial switch with your hostname configuration:

```bash
nix run nix-darwin --extra-experimental-features "nix-command flakes" -- switch --flake /etc/nix-darwin#HOSTNAME
```

Replace `HOSTNAME` with your configuration name (e.g., `mbp`, `mini`).

Start a new shell session after this completes.

## Step 6: Verify Installation

```bash
darwin-rebuild switch
```

This should complete without errors. Check that your tools are available:
```bash
which darwin-rebuild nvim git
brew list
```

## Daily Usage

To apply configuration changes:
```bash
darwin-rebuild switch
```

To update and apply:
```bash
cd /etc/nix-darwin && git pull && darwin-rebuild switch
```

## Adding a New Host

1. Add a new configuration in `flake.nix`:
```nix
darwinConfigurations = {
  # ... existing configs ...

  newhostname = mkDarwinConfig {
    hostname = "newhostname";
    appsModule = ./modules/apps.nix;      # or apps-mini.nix for minimal
    homeModule = ./home;                   # or ./home/mini.nix for minimal
  };
};
```

2. Commit and push to GitHub
3. Follow Steps 1-5 on the new machine

## Available Configurations

| Config | Description | Apps |
|--------|-------------|------|
| `mbp` | MacBook Pro - full desktop | All GUI apps, dev tools |
| `mini` | Mac Mini - minimal server | CLI tools only, Tailscale |

## Troubleshooting

### Nix installer fails with APFS volume error
Use the native macOS package installer instead of the shell script. See Step 1.

### `darwin-rebuild: command not found` after first switch
Start a new terminal session or run `exec zsh -l`.

### Homebrew module error during activation
Install Homebrew first (Step 2) before running darwin-rebuild.

### Git permission denied (publickey)
Set up SSH key and add to GitHub (Step 3).

### Permission denied creating /etc/nix-darwin
Create directory with sudo and chown to your user (Step 4).

### `brew: command not found` on Apple Silicon
Add Homebrew to PATH - see Step 2.
