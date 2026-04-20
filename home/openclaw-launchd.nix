# OpenClaw Gateway + Boot Review launchd agents
#
# Note: OpenClaw bootstraps its own PATH at startup (path-env.ts),
# ignoring EnvironmentVariables.PATH. User dirs like ~/bin are included
# via a local patch to path-env.ts. The PATH here is a fallback for
# any non-OpenClaw child processes.
{ config, lib, pkgs, ... }:

let
  homeDir = config.home.homeDirectory;
  openclawDir = "${homeDir}/openclaw";
  logsDir = "${homeDir}/.openclaw/logs";
in
{
  launchd.agents.openclaw-gateway = {
    enable = true;
    config = {
      Label = "ai.openclaw.gateway";
      ProgramArguments = [
        "/bin/bash" "-c"
        "touch ${homeDir}/.openclaw/.gateway-started; exec ${pkgs.nodejs_22}/bin/node ${openclawDir}/dist/index.js gateway --port 8080"
      ];
      EnvironmentVariables = {
        HOME = homeDir;
        PATH = builtins.concatStringsSep ":" [
          "${homeDir}/bin"
          "${homeDir}/.npm-global/bin"
          "${homeDir}/.homebrew/bin"
          "${homeDir}/.homebrew/sbin"
          "/usr/local/bin"
          "/usr/bin"
          "/bin"
          "/usr/sbin"
          "/sbin"
        ];
        NODE_EXTRA_CA_CERTS = "/etc/ssl/cert.pem";
        NODE_USE_SYSTEM_CA = "1";
        OPENCLAW_GATEWAY_PORT = "8080";
        OPENCLAW_LAUNCHD_LABEL = "ai.openclaw.gateway";
        OPENCLAW_SERVICE_KIND = "gateway";
        OPENCLAW_SERVICE_MARKER = "openclaw";
        GOG_ACCOUNT = "ian@rapidand.com";
        GOG_KEYRING_BACKEND = "file";
        GOG_KEYRING_PASSWORD = "jarvis";
        OLLAMA_API_KEY = "ollama-local";
      };
      RunAtLoad = true;
      KeepAlive = true;
      ThrottleInterval = 1;
      StandardOutPath = "${logsDir}/gateway.log";
      StandardErrorPath = "${logsDir}/gateway.err.log";
      Umask = 63; # 0077
    };
  };

  launchd.agents.openclaw-boot-review = {
    enable = true;
    config = {
      Label = "ai.openclaw.boot-review";
      ProgramArguments = [
        "/bin/bash"
        "${homeDir}/.openclaw/hooks/on-boot-review.sh"
      ];
      EnvironmentVariables = {
        HOME = homeDir;
        PATH = builtins.concatStringsSep ":" [
          "${homeDir}/bin"
          "${homeDir}/.npm-global/bin"
          "${homeDir}/.homebrew/bin"
          "/usr/local/bin"
          "/usr/bin"
          "/bin"
        ];
      };
      RunAtLoad = false;
      WatchPaths = [
        "${homeDir}/.openclaw/.gateway-started"
      ];
      StandardOutPath = "${logsDir}/boot-review.log";
      StandardErrorPath = "${logsDir}/boot-review.err.log";
    };
  };
}
