{ pkgs, config, lib, ... }:

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
    taps = [
      "openhue/cli"
      "steipete/tap"
    ];
    packages = [
      # OpenHue smart home control
      "openhue/cli/openhue-cli"
      # Packages from steipete/tap
      "steipete/tap/gogcli"
      "steipete/tap/goplaces"
      "steipete/tap/peekaboo"
      "steipete/tap/sag"
      "steipete/tap/spogo"
      "steipete/tap/summarize"
      "steipete/tap/wacli"
    ];
  };

  home = {
    username = "jarvis";
    homeDirectory = "/Users/jarvis";
    stateVersion = "24.11";

    packages = with pkgs; [
      # All utilities provided by core.nix and git.nix
    ];
  };

  # Add npm global bin to PATH for OpenClaw
  home.sessionPath = lib.mkBefore [
    "${config.home.homeDirectory}/bin"
    "${config.home.homeDirectory}/.npm-global/bin"
  ];

  programs.home-manager.enable = true;

  # Minimal starship prompt
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };
}
