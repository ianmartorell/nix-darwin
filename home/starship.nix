{...}: {
  programs.starship = {
    enable = true;

    enableBashIntegration = true;
    enableZshIntegration = true;
    enableNushellIntegration = true;

    settings = {
      character = {
        success_symbol = "[›](bold green)";
        error_symbol = "[›](bold red)";
      };

      # Command execution time
      cmd_duration = {
        min_time = 500;
        format = "took [$duration]($style) ";
      };

      # Directory - show more depth
      directory = {
        truncation_length = 5;
        truncate_to_repo = false;
      };

      # Git status - simplified
      git_status = {
        conflicted = "=";
        ahead = "⇡\${count}";
        behind = "⇣\${count}";
        diverged = "⇕⇡\${ahead_count}⇣\${behind_count}";
        untracked = "?";
        stashed = "\\$";
        modified = "!";
        staged = "[+\${count}](green)";
        renamed = "»";
        deleted = "✘";
      };

      aws = {
        symbol = "🅰 ";
      };
      gcloud = {
        # do not show the account/project's info
        # to avoid the leak of sensitive information when sharing the terminal
        format = "on [$symbol$active(\($region\))]($style) ";
        symbol = "🅶 ️";
      };
      bun = {
        symbol = "🍞 ";
      };
      nodejs = {
        format = "via [🤖 $version](bold green) ";
        detect_files = [
          "package.json"
          ".node-version"
          "!bun.lock"
        ];
      };
      python = {
        format = "via [🐍 $version](bold yellow) ";
      };
      rust = {
        format = "via [🦀 $version](bold red) ";
      };
      golang = {
        format = "via [🐹 $version](bold cyan) ";
      };
      conda = {
        symbol = "🐍 ";
      };

      # Nix shell indicator
      nix_shell = {
        format = "via [☃️ $state( \\($name\\))](bold blue) ";
      };
    };
  };
}
