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
    initExtra = ''
      export PATH="$HOME/bin:$HOME/.local/bin:$HOME/.npm-global/bin:/opt/homebrew/bin:$PATH"
      export npm_config_prefix="$HOME/.npm-global"
      mkdir -p "$HOME/.npm-global"
      mkdir -p "$HOME/.ssh/sockets"
      source ${pkgs.zsh-vi-mode}/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh
      source ${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

      # Autosuggestions and keybindings must be in zvm_after_init to work with vi-mode
      zvm_after_init_commands+=(
        'source ${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh'
        'bindkey "^[^?" backward-kill-word'  # Alt+Backspace to delete word
      )

      # Case-insensitive completion
      zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
    '';
  };

  home.shellAliases = {
    claude = "claude --dangerously-skip-permissions";
    urldecode = "python3 -c 'import sys, urllib.parse as ul; print(ul.unquote_plus(sys.stdin.read()))'";
    urlencode = "python3 -c 'import sys, urllib.parse as ul; print(ul.quote_plus(sys.stdin.read()))'";
  };
}
