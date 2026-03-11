{ username, config, lib, ... }:

{
  # import sub modules
  imports = [
    ./shell.nix
    ./core.nix
    ./git.nix
    ./gh.nix
    ./ssh.nix
    ./starship.nix
    ./karabiner.nix
    ./aerospace.nix
    ./nvim.nix
    ./zed.nix
    ./mpv.nix
  ];

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home = {
    username = username;
    homeDirectory = "/Users/${username}";

    sessionPath = lib.mkBefore [
      "${config.home.homeDirectory}/bin"
      "${config.home.homeDirectory}/.local/bin"
      "${config.home.homeDirectory}/.npm-global/bin"
    ];

    # This value determines the Home Manager release that your
    # configuration is compatible with. This helps avoid breakage
    # when a new Home Manager release introduces backwards
    # incompatible changes.
    #
    # You can update Home Manager without changing this value. See
    # the Home Manager release notes for a list of state version
    # changes in each release.
    stateVersion = "24.11";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
