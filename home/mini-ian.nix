{ username, ... }:

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
    packages = [ ]; # Add packages as needed
  };

  home = {
    username = username;
    homeDirectory = "/Users/${username}";
    stateVersion = "24.11";
  };

  programs.home-manager.enable = true;
}
