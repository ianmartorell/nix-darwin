{ ... }:

{
  # Mac Mini specific system configuration
  # This module contains settings specific to the mini server setup

  # Power management - disable sleep for 24/7 server operation
  # Prevents Tailscale disconnections and keeps OpenClaw bot responsive
  system.activationScripts.postActivation.text = ''
    echo "Configuring power management for server mode..."
    sudo pmset -a sleep 0
    sudo pmset -a disksleep 0
    sudo pmset -a powernap 0
    sudo pmset -a standby 0
  '';

  # Keep system awake permanently via caffeinate
  launchd.daemons.caffeinate = {
    command = "/usr/bin/caffeinate -s";
    serviceConfig = {
      Label = "com.openclaw.caffeinate";
      RunAtLoad = true;
      KeepAlive = true;
    };
  };

  # Allow jarvis user to run sudo without password for OpenClaw operations
  security.sudo.extraConfig = ''
    jarvis ALL=(ALL:ALL) NOPASSWD: ALL
  '';
}
