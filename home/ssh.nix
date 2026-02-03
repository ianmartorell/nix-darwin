{ ... }:
{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    # Host configurations
    matchBlocks = {
      "*" = {
        serverAliveInterval = 60;
        serverAliveCountMax = 3;
        extraOptions = {
          ControlMaster = "auto";
          ControlPath = "~/.ssh/sockets/%r@%h:%p";
          ControlPersist = "600";
        };
      };

      # Example host configuration (template)
      # "github.com" = {
      #   user = "git";
      #   identityFile = "~/.ssh/id_ed25519";
      # };
    };
  };
}
