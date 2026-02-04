{ pkgs, ... }:
{
  # Enable screen sharing for remote access
  system.activationScripts.postActivation.text = ''
    launchctl load -w /System/Library/LaunchDaemons/com.apple.screensharing.plist 2>/dev/null || true
  '';

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
