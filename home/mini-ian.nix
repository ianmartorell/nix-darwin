{ username, config, lib, ... }:

{
  # Minimal home config for Mac Mini (server/headless)
  imports = [
    ./shell.nix
    ./core.nix
    ./git.nix
    ./gh.nix
    ./ssh.nix
    ./starship.nix
    ./nvim.nix
    ./homebrew.nix
  ];

  # Per-user Homebrew installation
  homebrew = {
    enable = true;
    packages = [
      "cowsay"
      "curl"
      "gh"
      "httpie"
    ];
    casks = [
      "memo"
    ];
  };

  home = {
    username = username;
    homeDirectory = "/Users/${username}";
    stateVersion = "24.11";

    sessionPath = lib.mkBefore [
      "${config.home.homeDirectory}/bin"
      "${config.home.homeDirectory}/.local/bin"
      "${config.home.homeDirectory}/.npm-global/bin"
    ];
  };

  programs.home-manager.enable = true;
}
