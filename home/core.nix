{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # Archives
    zip
    xz
    unzip
    p7zip
    zstd

    # Search & Text Processing
    ripgrep
    jq
    yq-go
    fzf
    gnused
    gawk

    # Network
    aria2
    socat
    nmap

    # Nix Development
    nixd
    nil

    # Node.js
    deno
    node2nix
    nodejs_22

    # Linting
    markdownlint-cli

    # Containers
    colima
    docker

    # GNU Utilities
    file
    which
    tree
    gnutar

    # Security
    gnupg

    # Servers
    caddy

    # Productivity
    glow # markdown previewer

    # Fun
    cowsay
  ];

  programs = {
    # modern vim
    neovim = {
      enable = true;
      defaultEditor = true;
      vimAlias = true;
    };

    # A modern replacement for ‘ls’
    # useful in bash/zsh prompt, not in nushell.
    eza = {
      enable = true;
      git = true;
      icons = "auto";
      enableZshIntegration = true;
    };

    # terminal file manager
    yazi = {
      enable = true;
      enableZshIntegration = true;
      settings = {
        manager = {
          show_hidden = true;
          sort_dir_first = true;
          sort_by = "natural";
          sort_sensitive = false;
          sort_reverse = false;
          linemode = "size";
          show_symlink = true;
        };
        preview = {
          image_filter = "triangle";
          image_quality = 75;
          max_width = 600;
          max_height = 900;
          tab_size = 2;
        };
        opener = {
          edit = [
            { run = "nvim \"$@\""; block = true; for = "unix"; }
          ];
          open = [
            { run = "open \"$@\""; for = "macos"; }
          ];
        };
      };
      keymap = {
        manager.prepend_keymap = [
          { on = [ "g" "h" ]; run = "cd ~"; desc = "Go to home"; }
          { on = [ "g" "c" ]; run = "cd ~/Code"; desc = "Go to Code"; }
          { on = [ "g" "d" ]; run = "cd ~/Downloads"; desc = "Go to Downloads"; }
          { on = [ "g" "n" ]; run = "cd /etc/nix-darwin"; desc = "Go to nix-darwin"; }
          { on = [ "<C-n>" ]; run = "create"; desc = "Create file/directory"; }
        ];
      };
    };

    # skim provides a single executable: sk.
    # Basically anywhere you would want to use grep, try sk instead.
    skim = {
      enable = true;
      enableBashIntegration = true;
    };

    direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
      config.whitelist.prefix = [ "/Users/ian/.superset" ];
    };
  };
}
