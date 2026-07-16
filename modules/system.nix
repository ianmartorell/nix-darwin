{
  pkgs,
  username,
  ...
}: {
  imports = [
    ./defaults.nix
    ./fonts.nix
    ./security.nix
  ];

  # Required for user-specific options (homebrew, system.defaults, etc.)
  system.primaryUser = username;

  system = {
    stateVersion = 5;

    # Reload settings without logout/login
    activationScripts.postActivation.text = ''
      sudo -u ${username} /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
    '';
  };

  # Zsh as default shell
  programs.zsh.enable = true;
  environment.shells = [pkgs.zsh];

  # Timezone
  time.timeZone = "Europe/Madrid";
}
