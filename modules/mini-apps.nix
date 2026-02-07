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

    # Nix
    nixfmt-rfc-style
  ];
  environment.variables.EDITOR = "nvim";

  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "uninstall";
    };

    masApps = { };
    taps = [ ];
    brews = [ ];

    # Shared system services
    casks = [
      "tailscale-app"
    ];
  };
}
