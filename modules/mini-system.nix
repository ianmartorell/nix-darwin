{ ... }:

{
  # Mac Mini specific system configuration
  # This module contains settings specific to the mini server setup

  # Power management - disable sleep for 24/7 server operation
  # Prevents Tailscale disconnections and keeps OpenClaw bot responsive
  system.activationScripts.postActivation.text = ''
    echo "Configuring power management for server mode..."
    sudo pmset sleep 0
    sudo pmset disksleep 0
  '';
}
