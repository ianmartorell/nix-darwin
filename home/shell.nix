{ pkgs, ... }:
{
  programs.zsh = {
    enable = true;
    enableCompletion = true;

    history = {
      size = 5000;
      save = 5000;
      ignoreDups = true;
      ignoreSpace = true;
      share = true;
    };
    initContent = ''
      # Homebrew Node 24 (has patched SQLite for OpenClaw)
      export PATH="$HOME/.homebrew/opt/node@24/bin:$PATH"
      export npm_config_prefix="$HOME/.npm-global"
      mkdir -p "$HOME/.npm-global"
      mkdir -p "$HOME/.ssh/sockets"
      source ${pkgs.zsh-vi-mode}/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh
      source ${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

      # Autosuggestions and keybindings must be in zvm_after_init to work with vi-mode
      zvm_after_init() {
        source ${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh
        ZSH_AUTOSUGGEST_STRATEGY=(history completion)  # Try history first, then completions
        WORDCHARS=''${WORDCHARS//-}           # Treat dashes as word boundaries
        bindkey "^Y" autosuggest-accept      # Ctrl+Y accepts suggestion
        bindkey "^[^?" backward-kill-word    # Alt+Backspace deletes word

        # Unbind Emacs-style cursor keys to free them for other tools (e.g., Claude Code)
        bindkey -r "^B"  # backward-char (use left arrow or h)
        bindkey -r "^F"  # forward-char (use right arrow or l)
      }

      # Case-insensitive completion
      zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

      # Initialize zoxide only in interactive shells (avoids breaking non-interactive scripts)
      if [[ $- == *i* ]]; then
        eval "$(${pkgs.zoxide}/bin/zoxide init zsh --cmd cd)"
      fi

      # nix-darwin rebuild functions (runs locally if on target machine, otherwise SSHs)
      rebuild-mini() {
        if [[ $(hostname -s) == mini ]]; then
          rebuild
        else
          ssh mini.local 'cd /etc/nix-darwin && git pull --rebase && sudo darwin-rebuild switch --flake /etc/nix-darwin'
        fi
      }
      rebuild-mbp() {
        if [[ $(hostname -s) == mbp ]]; then
          rebuild
        else
          ssh mbp.local 'cd /etc/nix-darwin && git pull --rebase && sudo darwin-rebuild switch --flake /etc/nix-darwin'
        fi
      }
    '';
  };

  home.shellAliases = {
    cc = "claude --dangerously-skip-permissions";
    urldecode = "python3 -c 'import sys, urllib.parse as ul; print(ul.unquote_plus(sys.stdin.read()))'";
    urlencode = "python3 -c 'import sys, urllib.parse as ul; print(ul.quote_plus(sys.stdin.read()))'";

    # nix-darwin rebuild alias
    rebuild = "cd /etc/nix-darwin && sudo darwin-rebuild switch --flake /etc/nix-darwin";
  };
}
