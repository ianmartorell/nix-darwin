{
  pkgs,
  username,
  ...
}: {
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
    gnused
    gawk

    # Network
    aria2
    socat
    nmap

    # Nix Development
    nixd
    nil

    # Node.js (using Homebrew node@24 for OpenClaw SQLite compatibility)
    deno
    node2nix

    # Linting
    markdownlint-cli

    # Containers
    colima
    docker_29

    # Databases
    postgresql # provides psql client

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
    # claude-code installed via npm globally

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
            {
              run = "nvim \"$@\"";
              block = true;
              for = "unix";
            }
          ];
          open = [
            {
              run = "open \"$@\"";
              for = "macos";
            }
          ];
        };
      };
      keymap = {
        manager.prepend_keymap = [
          {
            on = ["g" "h"];
            run = "cd ~";
            desc = "Go to home";
          }
          {
            on = ["g" "c"];
            run = "cd ~/Code";
            desc = "Go to Code";
          }
          {
            on = ["g" "d"];
            run = "cd ~/Downloads";
            desc = "Go to Downloads";
          }
          {
            on = ["g" "n"];
            run = "cd /etc/nix-darwin";
            desc = "Go to nix-darwin";
          }
          {
            on = ["<C-n>"];
            run = "create";
            desc = "Create file/directory";
          }
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
      config.whitelist.prefix = ["/Users/${username}/.superset"];
    };

    # Smart cd that learns your most used directories
    # Note: zsh integration is manual in shell.nix to avoid breaking non-interactive shells
    zoxide = {
      enable = true;
      enableZshIntegration = false;
      options = ["--cmd cd"];
    };

    # Fuzzy finder with shell and tmux integration
    fzf = {
      enable = true;
      enableZshIntegration = true;
      tmux.enableShellIntegration = true;
    };

    tmux = {
      enable = true;
      prefix = "C-a";
      shell = "${pkgs.zsh}/bin/zsh";
      terminal = "tmux-256color";
      # NOTE: catppuccin is intentionally NOT here. It (and tmux-cpu/tmux-battery)
      # are loaded manually at the end of extraConfig, because Home Manager
      # sources `plugins` BEFORE extraConfig and the theme needs its options set
      # first / its status modules wired after. See the bottom of extraConfig.
      plugins = with pkgs.tmuxPlugins; [
        sensible
        yank
        vim-tmux-navigator
      ];
      extraConfig = ''
        # Start shell as login shell to ensure all config is sourced
        set -g default-command "${pkgs.zsh}/bin/zsh -l"

        # Enable mouse support
        set -g mouse on

        # True color support
        set-option -sa terminal-overrides ",xterm*:Tc"

        # Enable extended keys (for Shift+Enter, Ctrl+Shift+*, etc.)
        set -s extended-keys on
        set -as terminal-features 'xterm*:extkeys'

        # Allow programs to pass escape sequences through tmux (e.g. images, OSC 52)
        set -g allow-passthrough on

        # Switch to last window with prefix twice
        bind-key C-a last-window

        # set vi-mode
        set-window-option -g mode-keys vi
        # keybindings
        bind-key -T copy-mode-vi v send-keys -X begin-selection
        bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
        bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel

        # Open panes in current directory
        bind h split-window -v -c "#{pane_current_path}"
        bind v split-window -h -c "#{pane_current_path}"

        # New windows in current directory
        bind c new-window -c "#{pane_current_path}"

        # Shift arrow to switch windows
        bind -n S-Left previous-window
        bind -n S-Right next-window

        # Start windows and panes at 1, not 0
        set -g base-index 1
        set -g pane-base-index 1
        set-window-option -g pane-base-index 1
        set-option -g renumber-windows on

        # --- Catppuccin theme (loaded by hand, not via `plugins`) ---
        # Catppuccin v2 bakes its window/status formats at load time from the
        # @catppuccin_* options, and tmux-cpu / tmux-battery must rewrite
        # `status-right` AFTER it is set. Home Manager sources `plugins` before
        # this block, so we can't rely on that ordering — do it explicitly:
        #   1. set options  2. run catppuccin  3. set status-right  4. run cpu/battery
        set -g @catppuccin_flavor "mocha"
        set -g @catppuccin_window_status_style "rounded"

        # Window tab label: activity glyph + first 3 words of the pane title.
        # Claude Code sets the pane title (#T) to a long task summary via an OSC
        # escape; this keeps the first 4 space-separated tokens (glyph + 3 words),
        # trimming "✳ Add reject button for validated invoices…" to
        # "✳ Add reject button". Titles with fewer tokens are left unchanged.
        set -g @catppuccin_window_text " #{s|^([^ ]* [^ ]* [^ ]* [^ ]*) .*|\1|:pane_title}"
        set -g @catppuccin_window_current_text " #{s|^([^ ]* [^ ]* [^ ]* [^ ]*) .*|\1|:pane_title}"

        run-shell ${pkgs.tmuxPlugins.catppuccin}/share/tmux-plugins/catppuccin/catppuccin.tmux

        # Right status bar (minimal): CPU% + session.
        # cpu uses -F so its module text (carrying the #{cpu_percentage}
        # placeholder) is expanded into status-right, which tmux-cpu then
        # rewrites into a #(script) call.
        set -g  status-right-length 100
        set -g  status-left-length 100
        set -g  status-left ""
        set -gF status-right "#{E:@catppuccin_status_cpu}"
        set -ag status-right "#{E:@catppuccin_status_session}"

        run-shell ${pkgs.tmuxPlugins.cpu}/share/tmux-plugins/cpu/cpu.tmux
      '';
    };
  };
}
