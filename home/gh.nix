{...}: {
  programs.gh = {
    enable = true;

    settings = {
      # What protocol to use when performing git operations
      git_protocol = "https";

      # When to interactively prompt
      prompt = "enabled";

      # Preference for editor-based interactive prompting
      prefer_editor_prompt = "disabled";

      # Aliases allow you to create nicknames for gh commands
      aliases = {
        co = "pr checkout";
      };
    };
  };
}
