{ ... }:
{
  # Karabiner-Elements configuration via Home Manager
  xdg.configFile."karabiner/karabiner.json" = {
    text = builtins.toJSON {
      global = {
        check_for_updates_on_startup = true;
        show_in_menu_bar = false;
        show_profile_name_in_menu_bar = false;
        enable_notification_window = false;
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
              from.key_code = "grave_accent_and_tilde";
              to = [{ key_code = "non_us_backslash"; }];
            }
          ];
          virtual_hid_keyboard = {
            keyboard_type_v2 = "iso";
          };
        }
      ];
    };
  };
}
