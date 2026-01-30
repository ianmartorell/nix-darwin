{ ... }:

{
  # TouchID for sudo authentication
  security.pam.enableSudoTouchIdAuth = true;

  # Allow admin users to run sudo without password
  security.sudo.extraConfig = ''
    %admin ALL=(ALL:ALL) NOPASSWD: ALL
  '';
}
