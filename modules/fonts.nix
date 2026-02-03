{ pkgs, ... }:

{
  fonts = {
    packages = with pkgs; [
      # Icon Fonts
      material-design-icons
      font-awesome

      # Nerd Fonts (restructured in nixpkgs 25.x)
      nerd-fonts.symbols-only
      nerd-fonts.fira-code
      nerd-fonts.droid-sans-mono
      nerd-fonts.jetbrains-mono
      nerd-fonts.iosevka
      nerd-fonts.caskaydia-cove
      nerd-fonts.hack
      nerd-fonts.zed-mono
      nerd-fonts.blex-mono
    ];
  };
}
