{ pkgs, ... }:

{
  # Nix core configuration
  # Note: nix.enable is set to false for compatibility with Determinate Systems
  # Nix installer. This means nix-darwin won't manage the Nix installation itself.
  # Nix updates should be handled separately via the Determinate Systems installer.
  nix.enable = false;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Allow insecure packages (EOL versions needed for dependencies)
  nixpkgs.config.permittedInsecurePackages = [
    "lima-full-1.2.2"  # Dependency of colima, EOL but needed
    "lima-additional-guestagents-1.2.2"  # Dependency of colima, EOL but needed
  ];
}
