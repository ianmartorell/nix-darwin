# OpenClaw Gateway + Boot Review launchd agents
# Manages the gateway daemon and post-boot catch-up review.
#
# Replaces manually-managed plist files:
# - ~/Library/LaunchAgents/ai.openclaw.gateway.plist
# - ~/Library/LaunchAgents/ai.openclaw.boot-review.plist
#
# PATH is sourced from hm-session-vars.sh at launch, so nix-darwin
# PATH changes propagate automatically without touching plists.
#
# IMPORTANT: After enabling this, never run `openclaw gateway install`
# — it would overwrite the nix-managed symlink. Use `openclaw gateway restart`
# or `launchctl kickstart -k gui/$(id -u)/ai.openclaw.gateway` instead.
{ config, pkgs, ... }:

let
  homeDir = config.home.homeDirectory;
  openclawDir = "${homeDir}/openclaw";
  logsDir = "${homeDir}/.openclaw/logs";
  hmSessionVars = "/etc/profiles/per-user/${config.home.username}/etc/profile.d/hm-session-vars.sh";
in
{
  launchd.agents.openclaw-gateway = {
    enable = true;
    config = {
      Label = "ai.openclaw.gateway";
      ProgramArguments = [
        "/bin/bash"
        "-c"
        "source ${hmSessionVars} 2>/dev/null; touch ${homeDir}/.openclaw/.gateway-started; exec ${pkgs.nodejs_22}/bin/node ${openclawDir}/dist/index.js gateway --port 8080"
      ];
      EnvironmentVariables = {
        HOME = homeDir;
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
        "-c"
        "source ${hmSessionVars} 2>/dev/null; exec /bin/bash ${homeDir}/.openclaw/hooks/on-boot-review.sh"
      ];
      EnvironmentVariables = {
        HOME = homeDir;
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
