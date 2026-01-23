{ ... }:
{
  # AeroSpace configuration via Home Manager
  xdg.configFile."aerospace/aerospace.toml" = {
    text = ''
      # Reference: https://github.com/i3/i3/blob/next/etc/config

      config-version = 2

      # Start AeroSpace at login
      start-at-login = true

      # In i3, all workspaces are phantom
      persistent-workspaces = []

      # i3 doesn't have "normalizations" feature that why we disable them here.
      # But the feature is very helpful.
      # Normalizations eliminate all sorts of weird tree configurations that don't make sense.
      # Give normalizations a chance and enable them back.
      enable-normalization-flatten-containers = false
      enable-normalization-opposite-orientation-for-nested-containers = false

      # Mouse follows focus when focused monitor changes
      on-focused-monitor-changed = ['move-mouse monitor-lazy-center']

      # Start JankyBorders to highlight focused windows with colored borders
      after-startup-command = [
          # JankyBorders has a built-in detection of already running process,
          # so it won't be run twice on AeroSpace restart
          'exec-and-forget borders active_color=0xffe1e3e4 inactive_color=0xff494d64 width=5.0'
      ]

      # Gaps between windows
      [gaps]
      inner.horizontal = 4
      inner.vertical =   4
      outer.left =       4
      outer.bottom =     4
      outer.top =        4
      outer.right =      4

      [mode.main.binding]
          # See: https://nikitabobko.github.io/AeroSpace/goodies#open-a-new-window-with-applescript
          alt-enter = ''''exec-and-forget osascript -e '
          tell application "iTerm"
              create window with default profile
              activate
          end tell'
          ''''

          # See: https://nikitabobko.github.io/AeroSpace/commands#layout
          alt-slash = 'layout tiles horizontal vertical'
          alt-comma = 'layout accordion horizontal vertical'

          # See: https://nikitabobko.github.io/AeroSpace/commands#focus
          alt-h = 'focus left'
          alt-j = 'focus down'
          alt-k = 'focus up'
          alt-l = 'focus right'

          # See: https://nikitabobko.github.io/AeroSpace/commands#move
          alt-shift-h = 'move left'
          alt-shift-j = 'move down'
          alt-shift-k = 'move up'
          alt-shift-l = 'move right'

          # See: https://nikitabobko.github.io/AeroSpace/commands#resize
          alt-minus = 'resize smart -50'
          alt-equal = 'resize smart +50'

          # See: https://nikitabobko.github.io/AeroSpace/commands#workspace-back-and-forth
          alt-tab = 'workspace-back-and-forth'
          # See: https://nikitabobko.github.io/AeroSpace/commands#move-workspace-to-monitor
          alt-shift-tab = 'move-workspace-to-monitor --wrap-around next'

          # See: https://nikitabobko.github.io/AeroSpace/commands#mode
          alt-shift-semicolon = 'mode service'

          alt-1 = 'workspace 1'
          alt-2 = 'workspace 2'
          alt-3 = 'workspace 3'
          alt-4 = 'workspace 4'
          alt-5 = 'workspace 5'
          alt-6 = 'workspace 6'
          alt-7 = 'workspace 7'
          alt-8 = 'workspace 8'
          alt-9 = 'workspace 9'
          alt-0 = 'workspace 10'

          alt-shift-1 = 'move-node-to-workspace 1'
          alt-shift-2 = 'move-node-to-workspace 2'
          alt-shift-3 = 'move-node-to-workspace 3'
          alt-shift-4 = 'move-node-to-workspace 4'
          alt-shift-5 = 'move-node-to-workspace 5'
          alt-shift-6 = 'move-node-to-workspace 6'
          alt-shift-7 = 'move-node-to-workspace 7'
          alt-shift-8 = 'move-node-to-workspace 8'
          alt-shift-9 = 'move-node-to-workspace 9'
          alt-shift-0 = 'move-node-to-workspace 10'

      # 'service' binding mode declaration.
      # See: https://nikitabobko.github.io/AeroSpace/guide#binding-modes
      [mode.service.binding]
          esc = ['reload-config', 'mode main']
          r = ['flatten-workspace-tree', 'mode main'] # reset layout
          f = ['layout floating tiling', 'mode main'] # Toggle between floating and tiling layout
          backspace = ['close-all-windows-but-current', 'mode main']

          # sticky is not yet supported https://github.com/nikitabobko/AeroSpace/issues/2
          #s = ['layout sticky tiling', 'mode main']

          alt-shift-h = ['join-with left', 'mode main']
          alt-shift-j = ['join-with down', 'mode main']
          alt-shift-k = ['join-with up', 'mode main']
          alt-shift-l = ['join-with right', 'mode main']
    '';
  };
}
