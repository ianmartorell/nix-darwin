{ pkgs, ... }:
{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    initExtra = ''
      export PATH="$HOME/bin:$HOME/.local/bin:$HOME/.npm-global/bin:/opt/homebrew/bin:$PATH"
      export npm_config_prefix="$HOME/.npm-global"
      mkdir -p "$HOME/.npm-global"
      source ${pkgs.zsh-vi-mode}/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh
    '';
  };

  home.shellAliases = {
    nixfmt = "nixfmt-rfc-style";
    urldecode = "python3 -c 'import sys, urllib.parse as ul; print(ul.unquote_plus(sys.stdin.read()))'";
    urlencode = "python3 -c 'import sys, urllib.parse as ul; print(ul.quote_plus(sys.stdin.read()))'";
    remap-keychron = "/usr/bin/hidutil property --match '{\"ProductID\":0x2d1,\"VendorID\":0x3434,\"Product\":\"Keychron K13 Pro\"}' --set '{\"UserKeyMapping\":[{\"HIDKeyboardModifierMappingSrc\":0x700000039,\"HIDKeyboardModifierMappingDst\":0x700000029},{\"HIDKeyboardModifierMappingSrc\":0x700000035,\"HIDKeyboardModifierMappingDst\":0x700000064},{\"HIDKeyboardModifierMappingSrc\":0x700000064,\"HIDKeyboardModifierMappingDst\":0x700000031}]}'";
    gs = "git status";
    gd = "git diff";
    gdc = "git diff --cached";
    gc = "git commit";
    gcm = "git commit -m";
    gca = "git commit -am";
    gco = "git checkout";
    gb = "git branch";
    gp = "git push";
    gpl = "git pull";
    gss = "git stash";
    gsp = "git stash pop";
    gsl = "git stash list";
    gsc = "git stash clear";
  };
}
