{ ... }:

{
  xdg.configFile."zed/settings.json".text = builtins.toJSON {
    ui_font_family = "BlexMono Nerd Font";
    buffer_font_family = "BlexMono Nerd Font";
    features = {
      edit_prediction_provider = "zed";
    };
    vim_mode = true;
    ui_font_size = 16;
    buffer_font_size = 16;
    theme = {
      mode = "system";
      light = "One Light";
      dark = "Ayu Dark";
    };
    scrollbar = {
      show = "always";
    };
    inlay_hints = {
      enabled = false;
      show_type_hints = true;
    };
    language_overrides = {
      TypeScript = {
        formatter = {
          external = {
            command = "eslint_d";
            arguments = [
              "--stdin"
              "--fix"
              "--fix-to-stdout"
              "--stdin-filename"
              "{buffer_path}"
            ];
          };
        };
      };
      TSX = {
        formatter = {
          external = {
            command = "eslint_d";
            arguments = [
              "--stdin"
              "--fix"
              "--fix-to-stdout"
              "--stdin-filename"
              "{buffer_path}"
            ];
          };
        };
      };
    };
  };

  xdg.configFile."zed/keymap.json".text = builtins.toJSON [
    {
      context = "Workspace";
      bindings = { };
    }
    {
      context = "Editor";
      bindings = { };
    }
  ];
}
