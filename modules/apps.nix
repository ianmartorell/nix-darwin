{ pkgs, ... }:
{

  # Install packages from nix's official package repository.
  #
  # The packages installed here are available to all users, and are reproducible across machines, and are rollbackable.
  # But on macOS, it's less stable than homebrew.
  #
  # Related Discussion: https://discourse.nixos.org/t/darwin-again/29331
  environment.systemPackages = with pkgs; [
    neovim
    git
    lazygit
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
      "wget" # download tool
      "curl" # no not install curl via nixpkgs, it's not working well on macOS!
      "aria2" # download tool
      "httpie" # http client
      "gh" # github cli
      "litra" # logitech litra
      "flyctl" # fly.io cli
    ];

    # `brew install --cask`
    casks = [
      "stats"
      "raycast"
      "amie"
      "bitwarden"
      "loom"
      "ollama-app"
      "handbrake-app"
      "sonic-pi"
      "amazon-chime"

      "zen"
      "google-chrome"
      "arc"

      "slack"
      "cursor"
      "zed"
      "visual-studio-code"
      "linear-linear"
      "tableplus"
      "iterm2"

      "autodesk-fusion"
      "autofirma"
      "karabiner-elements"
      "nikitabobko/tap/aerospace"

      "spotify"
      "plex-media-server"

      "whatsapp"
      "telegram"
      "discord"
      "wechat"

      "orcaslicer"
      "openscad"
      "inkscape"
      "gimp"

      "tailscale-app"
      "transmission"
      "cyberduck"
      "windows-app"

      "libreoffice"

      "adobe-acrobat-reader"
      "steam"
      "nordvpn"
    ];
  };
}
