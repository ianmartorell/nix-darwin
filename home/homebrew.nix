# Per-user Homebrew installation via home-manager
# Each user gets their own Homebrew at ~/.homebrew
# This avoids permission conflicts on multi-user systems
{ config, lib, pkgs, ... }:

let
  homebrewPrefix = "${config.home.homeDirectory}/.homebrew";
in
{
  options.homebrew = {
    enable = lib.mkEnableOption "per-user Homebrew installation";

    packages = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "List of Homebrew formulae to install";
    };

    casks = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "List of Homebrew casks to install";
    };

    taps = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "List of Homebrew taps to add";
    };

    cleanup = lib.mkOption {
      type = lib.types.enum [ "none" "uninstall" "zap" ];
      default = "none";
      description = ''
        What to do with packages not listed in the configuration.
        - "none": leave unlisted packages installed
        - "uninstall": remove unlisted packages and casks
        - "zap": remove unlisted casks with --zap (removes all associated files)
      '';
    };
  };

  config = lib.mkIf config.homebrew.enable {
    # Add user's Homebrew to PATH
    home.sessionPath = [
      "${homebrewPrefix}/bin"
      "${homebrewPrefix}/sbin"
    ];

    # Set Homebrew environment variables
    home.sessionVariables = {
      HOMEBREW_PREFIX = homebrewPrefix;
      HOMEBREW_CELLAR = "${homebrewPrefix}/Cellar";
      HOMEBREW_REPOSITORY = homebrewPrefix;
      HOMEBREW_NO_AUTO_UPDATE = "1"; # Faster brew commands
    };

    # Install Homebrew and packages on activation
    home.activation.homebrew = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      # Install Homebrew if not present
      if [ ! -x "${homebrewPrefix}/bin/brew" ]; then
        echo "Installing Homebrew to ${homebrewPrefix}..."
        $DRY_RUN_CMD mkdir -p "${homebrewPrefix}"
        $DRY_RUN_CMD ${pkgs.git}/bin/git clone https://github.com/Homebrew/brew "${homebrewPrefix}"
      fi

      # Set up brew command for this activation
      export PATH="${homebrewPrefix}/bin:$PATH"
      export HOMEBREW_PREFIX="${homebrewPrefix}"
      export HOMEBREW_CELLAR="${homebrewPrefix}/Cellar"
      export HOMEBREW_REPOSITORY="${homebrewPrefix}"

      # Add taps
      ${lib.concatMapStringsSep "\n" (tap: ''
        if ! ${homebrewPrefix}/bin/brew tap | grep -q "^${tap}$"; then
          $DRY_RUN_CMD ${homebrewPrefix}/bin/brew tap ${tap}
        fi
      '') config.homebrew.taps}

      # Install formulae
      ${lib.concatMapStringsSep "\n" (pkg: ''
        if ! ${homebrewPrefix}/bin/brew list --formula | grep -q "^${pkg}$"; then
          $DRY_RUN_CMD ${homebrewPrefix}/bin/brew install ${pkg}
        fi
      '') config.homebrew.packages}

      # Install casks
      ${lib.concatMapStringsSep "\n" (cask: ''
        if ! ${homebrewPrefix}/bin/brew list --cask | grep -q "^${cask}$"; then
          $DRY_RUN_CMD ${homebrewPrefix}/bin/brew install --cask ${cask}
        fi
      '') config.homebrew.casks}

      ${lib.optionalString (config.homebrew.cleanup != "none") ''
        # Cleanup: remove unlisted formulae
        for pkg in $(${homebrewPrefix}/bin/brew list --formula -1); do
          case "$pkg" in
            ${if config.homebrew.packages == [] then ''__NOTHING_MATCHES__'' else lib.concatMapStringsSep "|" (pkg: ''"${pkg}"'') config.homebrew.packages})
              ;;
            *)
              echo "Removing unlisted formula: $pkg"
              $DRY_RUN_CMD ${homebrewPrefix}/bin/brew uninstall --formula "$pkg"
              ;;
          esac
        done

        # Cleanup: remove unlisted casks
        for cask in $(${homebrewPrefix}/bin/brew list --cask -1); do
          case "$cask" in
            ${if config.homebrew.casks == [] then ''__NOTHING_MATCHES__'' else lib.concatMapStringsSep "|" (cask: ''"${cask}"'') config.homebrew.casks})
              ;;
            *)
              echo "Removing unlisted cask: $cask"
              $DRY_RUN_CMD ${homebrewPrefix}/bin/brew uninstall --cask ${lib.optionalString (config.homebrew.cleanup == "zap") "--zap"} "$cask"
              ;;
          esac
        done
      ''}
    '';
  };
}
