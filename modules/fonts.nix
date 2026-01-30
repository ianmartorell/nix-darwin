{ pkgs, ... }:

{
  fonts = {
    packages = with pkgs; [
      # Icon Fonts
      material-design-icons
      font-awesome

      # Nerd Fonts
      # https://github.com/NixOS/nixpkgs/blob/nixos-24.05/pkgs/data/fonts/nerdfonts/shas.nix
      (nerdfonts.override {
        fonts = [
          "NerdFontsSymbolsOnly"
          "FiraCode"
          "DroidSansMono"
          "JetBrainsMono"
          "Iosevka"
          "CascadiaCode"
          "Hack"
          "ZedMono"
          "IBMPlexMono"
        ];
      })
    ];
  };
}
