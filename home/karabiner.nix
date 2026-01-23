{ ... }:
{
  # Karabiner-Elements configuration via Home Manager
  xdg.configFile."karabiner/karabiner.json" = {
    text = builtins.toJSON {
      global = {
        check_for_updates_on_startup = true;
        show_in_menu_bar = true;
        show_profile_name_in_menu_bar = false;
      };
      profiles = [
        {
          name = "Default profile";
          complex_modifications = {
            parameters = {};
            rules = [];
          };
          devices = [];
          fn_function_keys = [];
          simple_modifications = [
            {
              from.key_code = "caps_lock";
              to = [{ key_code = "escape"; }];
            }
            {
              from.key_code = "non_us_backslash";
              to = [{ key_code = "grave_accent_and_tilde"; }];
            }
          ];
          virtual_hid_keyboard = {
            country_code = 0;
            indicate_sticky_modifier_keys_state = true;
            mouse_key_xy_scale = 100;
          };
        }
      ];
    };
  };
}
