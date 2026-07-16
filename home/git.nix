{
  lib,
  username,
  fullname,
  useremail,
  ...
}: {
  # `programs.git` will generate the config file: ~/.config/git/config
  # to make git use this config file, `~/.gitconfig` should not exist!
  #
  #    https://git-scm.com/docs/git-config#Documentation/git-config.txt---global
  home.activation.removeExistingGitconfig = lib.hm.dag.entryBefore ["checkLinkTargets"] ''
    rm -f ~/.gitconfig
  '';

  # Git aliases (shell aliases for git commands)
  home.shellAliases = {
    ga = "git add";
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
    gl = "git log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset'";
  };

  programs.git = {
    enable = true;
    lfs.enable = true;

    includes = [
      {
        # use different email & name for work
        path = "~/Code/rapidand/.gitconfig";
        condition = "gitdir:~/Code/rapidand/";
      }
    ];

    settings = {
      user.name = fullname;
      user.email = useremail;
      init.defaultBranch = "main";
      push.autoSetupRemote = true;
      pull.rebase = true;
      safe.directory = "/private/etc/nix-darwin";
    };

    # signing = {
    #   key = "xxx";
    #   signByDefault = true;
    # };
  };

  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options = {
      features = "side-by-side";
    };
  };
}
