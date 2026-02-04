{ pkgs, ... }:
{
  # Enable screen sharing for remote access
  system.screenSharing.enable = true;

  # Minimal server packages for Mac Mini
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

    masApps = {};
    taps = [];

    # CLI tools only
    brews = [
      "wget"
      "curl"
      "aria2"
      "httpie"
      "gh"
    ];

    # Minimal GUI apps for server
    casks = [
      "tailscale-app"
    ];
  };
}
