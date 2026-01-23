{ ... }:
{
  # Neovim configuration via symlink to kickstart.nvim-based setup
  xdg.configFile."nvim" = {
    source = ./nvim;
    recursive = true;
  };
}
