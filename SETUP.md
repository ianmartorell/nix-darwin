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

## Step 2: Install Homebrew (Optional)

**For MacBook Pro (mbp):** Install system Homebrew for GUI apps and system-wide tools:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

**For Mac Mini (mini):** Install system Homebrew for shared services (e.g., tailscale). Per-user Homebrew installations will also be automatically set up by nix-darwin at `~/.homebrew` for user-specific packages.

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
sudo mkdir /etc/nix-darwin
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
sudo darwin-rebuild switch
```

This should complete without errors. Check that your tools are available:
```bash
which darwin-rebuild nvim git
brew list
```

## Daily Usage

To apply configuration changes:
```bash
sudo darwin-rebuild switch
```

To update and apply:
```bash
cd /etc/nix-darwin && git pull && sudo darwin-rebuild switch
```

## Adding a New Host

1. **Create user config file** in `home/`:
   - For a new machine: `home/{machine}-{user}.nix` (e.g., `home/laptop-ian.nix`)
   - Import the modules you need (shell, core, git, etc.)
   - Configure per-user settings (homebrew packages, etc.)

2. **Create or reuse machine apps file** in `modules/`:
   - For full desktop: `modules/{machine}-apps.nix` (like `mbp-apps.nix`)
   - For minimal server: `modules/{machine}-apps.nix` (like `mini-apps.nix`)

3. **Add configuration to `flake.nix`**:
```nix
darwinConfigurations = {
  # ... existing configs ...

  newhostname = mkDarwinConfig {
    hostname = "newhostname";
    appsModule = ./modules/newhostname-apps.nix;
    homeModule = ./home/newhostname-ian.nix;
  };
};
```

4. Commit and push to GitHub
5. Follow Steps 1-5 on the new machine

**For multi-user machines** (like mini), define additional users in the machine config and add their home-manager configs. See the `mini` configuration in `flake.nix` for an example.

## Available Configurations

| Config | Description | Users | Homebrew Setup |
|--------|-------------|-------|----------------|
| `mbp` | MacBook Pro - full desktop | ian | System Homebrew at `/opt/homebrew` |
| `mini` | Mac Mini - minimal server | ian, jarvis | System + per-user Homebrew |

**User configs:**
- `home/mbp-ian.nix` - Ian's full desktop environment (mbp)
- `home/mini-ian.nix` - Ian's minimal server setup (mini)
- `home/mini-jarvis.nix` - Jarvis (OpenClaw AI agent) isolated config (mini)

**Why per-user Homebrew on mini?**
Multiple users need independent package management without permission conflicts. Each user gets their own Homebrew installation automatically.

## Troubleshooting

### Nix installer fails with APFS volume error
Use the native macOS package installer instead of the shell script. See Step 1.

### `darwin-rebuild: command not found` after first switch
Start a new terminal session or run `exec zsh -l`.

### Homebrew module error during activation
Install system Homebrew first (Step 2) before running darwin-rebuild. Per-user Homebrew installations on mini are also installed automatically.

### Git permission denied (publickey)
Set up SSH key and add to GitHub (Step 3).

### Permission denied creating /etc/nix-darwin
Create directory with `sudo mkdir /etc/nix-darwin` (Step 4).
