{
  pkgs,
  config,
  lib,
  ...
}: {
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
      "openclaw/tap"
    ];
    packages = [
      # OpenHue smart home control
      "openhue/cli/openhue-cli"
      # OpenClaw CLIs (migrated from steipete/tap to openclaw/tap)
      "openclaw/tap/gogcli"
      "openclaw/tap/goplaces"
      "openclaw/tap/wacli"
      # Packages from steipete/tap
      "steipete/tap/peekaboo"
      "steipete/tap/sag"
      "steipete/tap/spogo"
      # summarize migrated to homebrew/core
      "summarize"
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
    "${config.home.homeDirectory}/.local/bin"
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
