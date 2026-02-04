{ pkgs, ... }:

{
  # Minimal home config for jarvis (OpenClaw AI agent)
  imports = [
    ./shell.nix
  ];

  home = {
    username = "jarvis";
    homeDirectory = "/Users/jarvis";
    stateVersion = "24.11";

    packages = with pkgs; [
      # Node.js for OpenClaw
      nodejs_22

      # Basic utilities
      ripgrep
      jq
      git
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
