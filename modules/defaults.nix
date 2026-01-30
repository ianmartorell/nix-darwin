{ ... }:

###################################################################################
#
#  macOS System Defaults
#
#  All the configuration options are documented here:
#    https://daiderd.com/nix-darwin/manual/index.html#sec-options
#  Incomplete list of macOS `defaults` commands:
#    https://github.com/yannbertrand/macos-defaults
#
###################################################################################
{
  system.defaults = {
    menuExtraClock.Show24Hour = true;

    # Dock
    dock = {
      autohide = false;
      autohide-delay = 0.0;
      autohide-time-modifier = 0.0;
      show-recents = false;
      expose-group-apps = true;
      mru-spaces = false;
      tilesize = 72;
      mineffect = "scale";
      minimize-to-application = true;

      # Hot Corners
      wvous-tl-corner = 2; # top-left - Mission Control
      wvous-tr-corner = 2; # top-right - Mission Control
      wvous-bl-corner = 3; # bottom-left - Application Windows
      wvous-br-corner = 4; # bottom-right - Desktop
    };

    # Finder
    finder = {
      _FXShowPosixPathInTitle = true;
      AppleShowAllExtensions = true;
      FXEnableExtensionChangeWarning = false;
      QuitMenuItem = true;
      ShowPathbar = true;
      ShowStatusBar = true;
    };

    # Trackpad
    trackpad = {
      Clicking = true;
      TrackpadRightClick = true;
      TrackpadThreeFingerDrag = false;
    };

    # Login Window
    loginwindow = {
      GuestEnabled = false;
    };

    # Global Domain
    NSGlobalDomain = {
      "com.apple.swipescrolldirection" = true;
      "com.apple.sound.beep.feedback" = 0;
      AppleInterfaceStyle = "Dark";
      AppleKeyboardUIMode = 3;
      ApplePressAndHoldEnabled = false;
      InitialKeyRepeat = 15;
      KeyRepeat = 4;
      NSAutomaticCapitalizationEnabled = false;
      NSAutomaticDashSubstitutionEnabled = false;
      NSAutomaticPeriodSubstitutionEnabled = false;
      NSAutomaticQuoteSubstitutionEnabled = false;
      NSAutomaticSpellingCorrectionEnabled = false;
      NSNavPanelExpandedStateForSaveMode = true;
      NSNavPanelExpandedStateForSaveMode2 = true;
      NSDocumentSaveNewDocumentsToCloud = false;
      AppleShowScrollBars = "Always";
      PMPrintingExpandedStateForPrint = true;
      PMPrintingExpandedStateForPrint2 = true;
      AppleWindowTabbingMode = "manual";
    };

    # Custom User Preferences (settings not directly supported by nix-darwin)
    CustomUserPreferences = {
      ".GlobalPreferences" = {
        AppleSpacesSwitchOnActivate = true;
      };
      NSGlobalDomain = {
        WebKitDeveloperExtras = true;
      };
      "com.apple.finder" = {
        ShowExternalHardDrivesOnDesktop = false;
        ShowHardDrivesOnDesktop = false;
        ShowMountedServersOnDesktop = false;
        ShowRemovableMediaOnDesktop = false;
        _FXSortFoldersFirst = true;
        FXDefaultSearchScope = "SCcf";
      };
      "com.apple.desktopservices" = {
        DSDontWriteNetworkStores = true;
        DSDontWriteUSBStores = true;
      };
      "com.apple.WindowManager" = {
        DisableTilingAnimations = true;
      };
      "com.apple.screensaver" = {
        askForPasswordDelay = 10;
      };
      "com.apple.screencapture" = {
        location = "~/Pictures/Screenshots";
        type = "png";
      };
      "com.apple.ImageCapture".disableHotPlug = true;
      "com.apple.symbolichotkeys" = {
        AppleSymbolicHotKeys = {
          "60" = { enabled = false; };
          "61" = {
            enabled = true;
            value = {
              parameters = [ 49 262144 ];
              type = "standard";
            };
          };
          "64" = { enabled = false; };
        };
      };
      "com.apple.print.PrintingPrefs" = {
        "Quit When Finished" = true;
      };
      "com.apple.TimeMachine".DoNotOfferNewDisksForBackup = true;
      "com.apple.commerce".AutoUpdate = true;
      "com.apple.ActivityMonitor" = {
        ShowCategory = 0;
        IconType = 5;
      };
      "com.apple.TextEdit" = {
        RichText = 0;
        PlainTextEncoding = 4;
        PlainTextEncodingForWrite = 4;
      };
      "com.apple.DiskUtility" = {
        DUDebugMenuEnabled = true;
        "advanced-image-options" = true;
      };
      "com.googlecode.iterm2" = {
        PromptOnQuit = false;
        OnlyWhenMoreTabs = true;
        HideTab = false;
        AlternateMouseScroll = true;
        FocusFollowsMouse = false;
        OpenTmuxWindowsIn = 2;
        HapticFeedbackForEsc = false;
        TabStyleWithAutomaticOption = 5;
      };
      "com.apple.Safari" = {
        IncludeDevelopMenu = true;
        ShowFavoritesBar = true;
        AutoOpenSafeDownloads = false;
        ShowOverlayStatusBar = true;
        WebKitDeveloperExtrasEnabledPreferenceKey = true;
        "com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled" = true;
      };
    };
  };
}
