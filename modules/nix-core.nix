{ pkgs, lib, ... }:

{
  # Disable nix-darwin's Nix management to work with Determinate Systems installer
  nix.enable = false;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
}
