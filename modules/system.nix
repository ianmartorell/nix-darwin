{ pkgs, ... }:

{
  imports = [
    ./defaults.nix
    ./fonts.nix
    ./security.nix
  ];

  system = {
    stateVersion = 5;

    # Reload settings without logout/login
    activationScripts.postUserActivation.text = ''
      /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
    '';
  };

  # Zsh as default shell
  programs.zsh.enable = true;
  environment.shells = [ pkgs.zsh ];

  # Timezone
  time.timeZone = "Europe/Madrid";
}
