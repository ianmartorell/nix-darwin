{ pkgs, ... }:
{
  # Minimal server packages for Mac Mini
  # Note: This machine uses per-user Homebrew installations (see home/mini-*.nix)
  # rather than system-level Homebrew to avoid permission conflicts between users.

  environment.systemPackages = with pkgs; [
    # Editors
    neovim

    # Version Control
    git
    lazygit

    # Nix
    nixfmt-rfc-style
  ];
  environment.variables.EDITOR = "nvim";
}
