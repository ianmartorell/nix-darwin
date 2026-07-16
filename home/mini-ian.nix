{
  username,
  config,
  lib,
  ...
}: {
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
      "node@24"
    ];
    casks = [
      "memo"
    ];
  };

  home = {
    username = username;
    homeDirectory = "/Users/${username}";
    stateVersion = "24.11";

    # node@24 goes here rather than in shell.nix's interactive-only export so
    # that non-interactive shells (`ssh mini '<cmd>'`) can find node too.
    sessionPath = lib.mkBefore [
      "${config.home.homeDirectory}/bin"
      "${config.home.homeDirectory}/.local/bin"
      "${config.home.homeDirectory}/.npm-global/bin"
      "${config.home.homeDirectory}/.homebrew/opt/node@24/bin"
    ];
  };

  programs.home-manager.enable = true;
}
