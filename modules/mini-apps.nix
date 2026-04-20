{ pkgs, ... }:
{
  # Minimal server packages for Mac Mini
  # Note: This machine uses per-user Homebrew installations (see home/mini-*.nix)
  # for most packages. System-level Homebrew is only used for shared services.

  environment.systemPackages = with pkgs; [
    # Editors
    neovim

    # Version Control
    git
    lazygit

    # Development
    bun

    # Google Workspace admin
    gam

    # Nix
    nixfmt-rfc-style
  ];
  environment.variables.EDITOR = "nvim";

  # System-level Homebrew for shared system services only
  # Per-user packages are managed in home/mini-ian.nix and home/mini-jarvis.nix
  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = true;
      upgrade = true;
    };

    masApps = { };
    taps = [ ];
    brews = [
      "wget"  # Available to all users, uses bottles at system location
    ];

    # System-level services and apps that require elevated privileges
    casks = [
      # Note: tailscale-app is already installed manually and should not be managed by Homebrew
      # to avoid losing configuration. Leave it as a manual installation.
    ];
  };
}
