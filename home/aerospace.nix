{...}: {
  # AeroSpace configuration via symlink
  xdg.configFile."aerospace/aerospace.toml" = {
    source = ./aerospace/aerospace.toml;
  };
}
