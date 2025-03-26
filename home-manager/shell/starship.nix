{
  lib,
  ...
}:
{
  programs.starship = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
    settings = {
      add_newline = false;
      line_break = {
        disabled = true;
      };
      format = lib.concatStringsSep "" [
        # "$username"
        # "$hostname"
        "$directory"
        "$git_branch"
        "$git_state"
        "$git_status"
        "$nix_shell"
        # "$cmd_duration"
        # "$line_break"
        # "$python"
        # "$time"
        "$character"
      ];
      # format = "$directory$git_branch$git_state$git_status$nix_shell$character";
      right_format = lib.concatStringsSep "" [
        "$cmd_duration"
        "$time"
      ];
      # right_format = "$cmd_duration$time";

      character = {
        error_symbol = "[❯](red)";
        success_symbol = "[❯](green)"; # fg:46
        vimcmd_symbol = "[❮](green)";
      };
      cmd_duration = {
        format = "[$duration]($style) ";
        style = "fg:108";
      };
      directory = {
        truncation_length = 3;
        truncation_symbol = "…/";
        format = "[$path]($style)[$read_only]($read_only_style) ";
        style = "fg:45";
      };
      git_branch = {
        format = "[$branch]($style) ";
        style = "fg:46";
      };
      git_state = {
        format = "([$state( $progress_current/$progress_total)]($style)\) ";
        style = "fg:202";
      };
      git_status = {
        conflicted = "=\($count\) ";
        deleted = "✘\($count\) ";
        format = "[$conflicted$stashed$deleted$renamed$staged$modified$untracked$ahead$behind$diverged]($style)";
        modified = "!\($count\) ";
        renamed = "»\($count\) ";
        staged = "+\($count\) ";
        stashed = "\\$\($count\) ";
        style = "fg:220";
        untracked = "?\($count\) ";
        ahead = "⇡\($count\) ";
        behind = "⇣\($count\) ";
        diverged = "⇕⇡\($ahead_count\)⇣\($behind_count\) ";
      };
      time = {
        format = "[$time]($style)";
        style = "fg:109";
        time_format = "%T";
        disabled = false;
      };
      nix_shell = {
        format = "[$symbol]($style)";
        symbol = "❄️ ";
        style = "blue";
      };
      # python = {
      #   format = "[$virtualenv]($style) ";
      #   style = "bright-black";
      # };
    };
  };

  # some sort of race condition with kitty and starship
  # https://github.com/kovidgoyal/kitty/issues/4476#issuecomment-1013617251
  programs.kitty.shellIntegration.enableBashIntegration = false;
}
