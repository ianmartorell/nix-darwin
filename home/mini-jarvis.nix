{ pkgs, ... }:

{
  # Minimal home config for jarvis (OpenClaw AI agent)
  imports = [
    ./shell.nix
    ./core.nix
    ./git.nix
    ./homebrew.nix
    ./nvim.nix
  ];

  # Per-user Homebrew installation
  homebrew = {
    enable = true;
    taps = [ ];
    packages = [ ]; # bird package URL is currently broken
  };

  home = {
    username = "jarvis";
    homeDirectory = "/Users/jarvis";
    stateVersion = "24.11";

    packages = with pkgs; [
      # All utilities provided by core.nix and git.nix
    ];

    # Add npm global bin to PATH for OpenClaw
    sessionPath = [
      "$HOME/.npm-global/bin"
    ];
  };

  programs.home-manager.enable = true;

  # Minimal starship prompt
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };
}
