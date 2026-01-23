{ pkgs, ... }:

{
  # Nix core configuration
  # Note: nix.enable is set to false for compatibility with Determinate Systems
  # Nix installer. This means nix-darwin won't manage the Nix installation itself.
  # Nix updates should be handled separately via the Determinate Systems installer.
  nix.enable = false;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
}
