{...}: {
  programs.mpv = {
    enable = true;
    config = {
      # Video output
      vo = "gpu";
      hwdec = "auto-safe";

      # OSD/UI
      osd-font = "BlexMono Nerd Font";
      osd-font-size = 32;
      osd-bar-h = 2;
      osd-bar-w = 60;

      # Subtitles
      sub-auto = "fuzzy";
      sub-font = "BlexMono Nerd Font";
      sub-font-size = 36;

      # Audio
      volume = 100;
      volume-max = 150;

      # Window
      keep-open = true;
      autofit-larger = "90%x90%";

      # Screenshots
      screenshot-format = "png";
      screenshot-directory = "~/Pictures/Screenshots";

      # Cache
      cache = true;
      demuxer-max-bytes = "150MiB";
      demuxer-max-back-bytes = "75MiB";
    };

    bindings = {
      # Vim-like navigation
      "l" = "seek 5";
      "h" = "seek -5";
      "j" = "seek -60";
      "k" = "seek 60";
      "L" = "seek 30";
      "H" = "seek -30";

      # Volume
      "=" = "add volume 5";
      "-" = "add volume -5";

      # Speed
      "[" = "multiply speed 0.9";
      "]" = "multiply speed 1.1";
      "BS" = "set speed 1.0";

      # Subtitles
      "z" = "add sub-delay -0.1";
      "Z" = "add sub-delay 0.1";

      # Quit
      "q" = "quit";
      "Q" = "quit-watch-later";
    };
  };
}
