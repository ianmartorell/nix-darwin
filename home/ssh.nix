{ ... }:
{
  programs.ssh = {
    enable = true;

    # Global settings
    controlMaster = "auto";
    controlPath = "~/.ssh/sockets/%r@%h:%p";
    controlPersist = "600";

    # Host configurations
    matchBlocks = {
      "*" = {
        serverAliveInterval = 60;
        serverAliveCountMax = 3;
      };

      # Example host configuration (template)
      # "github.com" = {
      #   user = "git";
      #   identityFile = "~/.ssh/id_ed25519";
      # };
    };
  };
}
