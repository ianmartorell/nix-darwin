{ pkgs, ... }:
{

  # Install packages from nix's official package repository.
  #
  # The packages installed here are available to all users, and are reproducible across machines, and are rollbackable.
  # But on macOS, it's less stable than homebrew.
  #
  # Related Discussion: https://discourse.nixos.org/t/darwin-again/29331
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
      # 'zap': uninstalls all formulae(and related files) not listed in the generated Brewfile
      cleanup = "uninstall";
    };

    # Applications to install from Mac App Store using mas.
    # You need to install all these Apps manually first so that your apple account have records for them.
    # otherwise Apple Store will refuse to install them.
    # For details, see https://github.com/mas-cli/mas
    masApps = {};

    taps = [
      "timrogers/tap"
      "nikitabobko/tap"
    ];

    # `brew install`
    brews = [
      # Network / Download
      "wget"
      "curl" # do not install via nixpkgs, not working well on macOS
      "aria2"
      "httpie"

      # Development
      "gh" # github cli
      "flyctl" # fly.io cli

      # Hardware
      "litra" # logitech litra light control
    ];

    # `brew install --cask`
    casks = [
      # System Utilities
      "stats"
      "raycast"
      "karabiner-elements"
      "nikitabobko/tap/aerospace"
      "tailscale-app"
      "nordvpn"

      # Productivity
      "amie"
      "sunsama"
      "bitwarden"
      "loom"
      "wispr-flow"
      "libreoffice"
      "adobe-acrobat-reader"

      # Browsers
      "zen"
      "google-chrome"
      "arc"

      # Development
      "iterm2"
      "cursor"
      "zed"
      "visual-studio-code"
      "tableplus"
      "superset"
      "insomnia"
      "linear-linear"

      # AI
      "claude"
      "ollama-app"
      "comet"

      # Communication
      "slack"
      "amazon-chime"
      "whatsapp"
      "telegram"
      "discord"
      "wechat"

      # Media
      "spotify"
      "plex-media-server"
      "stolendata-mpv"
      "handbrake-app"
      "sonic-pi"

      # Design & CAD
      "autodesk-fusion"
      "freecad"
      "orcaslicer"
      "openscad"
      "inkscape"
      "gimp"

      # File Transfer & Remote
      "transmission"
      "cyberduck"
      "windows-app"

      # Gaming
      "steam"
      "nvidia-geforce-now"

      # Government / Signing
      "autofirma"
    ];
  };
}
