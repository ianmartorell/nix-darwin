{ pkgs, ... }:
{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    initExtra = ''
      export PATH="$HOME/bin:$HOME/.local/bin:$HOME/.npm-global/bin:/opt/homebrew/bin:$PATH"
      export npm_config_prefix="$HOME/.npm-global"
      mkdir -p "$HOME/.npm-global"
      mkdir -p "$HOME/.ssh/sockets"
      source ${pkgs.zsh-vi-mode}/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh

      # Alt+Backspace to delete word (must be in zvm_after_init to work with vi-mode)
      zvm_after_init_commands+=('bindkey "^[^?" backward-kill-word')
    '';
  };

  home.shellAliases = {
    claude = "claude --dangerously-skip-permissions";
    urldecode = "python3 -c 'import sys, urllib.parse as ul; print(ul.unquote_plus(sys.stdin.read()))'";
    urlencode = "python3 -c 'import sys, urllib.parse as ul; print(ul.quote_plus(sys.stdin.read()))'";
  };
}
