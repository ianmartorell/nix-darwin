{ ... }:
{
  # Neovim configuration via symlink to kickstart.nvim-based setup
  xdg.configFile."nvim" = {
    source = ./nvim;
    recursive = true;
  };

  # Markdownlint configuration for nvim-lint
  home.file.".markdownlint.json".text = builtins.toJSON {
    MD024 = false; # Allow duplicate headings
    MD009 = false; # Allow trailing spaces
    MD013 = false; # Allow long lines
  };
}
