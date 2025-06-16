{
  pkgs,
  lib,
  ...
}:
{
  # https://zed.dev/
  # https://github.com/zed-industries/zed
  # https://wiki.nixos.org/wiki/Zed
  programs.zed-editor = {
    enable = true;
    package = pkgs.zed-editor-fhs;

    # https://zed.dev/docs/extensions
    # https://github.com/zed-industries/extensions/tree/main/extensions
    extensions = [
      "html" # https://github.com/zed-industries/zed/tree/main/extensions/html
      "toml" # https://github.com/zed-industries/zed/tree/main/extensions/toml
      "nix" # https://github.com/zed-extensions/nix
      "git-firefly" # https://github.com/d1y/git_firefly
      "ruff" # https://github.com/zed-industries/zed/tree/main/extensions/ruff
      "python-lsp" # https://github.com/rgbkrk/python-lsp-zed-extension
      "fish" # https://github.com/hasit/zed-fish
      "rainbow-csv" # https://github.com/Kalmaegi/zed-rainbow-csv/tree/81bfb05d56a5302bd821230e83840230fd558c65
      "basedpyright" # https://github.com/m1guer/basedpyright-zed
      "latex" # https://github.com/rzukic/zed-latex/
      "log" # https://github.com/zed-extensions/log
      "catppuccin" # https://github.com/catppuccin/zed
      "catppuccin-icons" # https://github.com/catppuccin/zed-icons
    ];

    # extension and language dependencies
    extraPackages = with pkgs; [
      # nix
      nixd
      nil
      # alejandra
      nixfmt-rfc-style

      # python
      ruff
      pyright
      basedpyright
      python3Packages.python-lsp-server

      # javascript
      eslint

      # html
      vscode-langservers-extracted
      openssl

      # texliv
      texliveFull
    ];

    ## everything inside of these brackets are Zed options.
    # https://zed.dev/docs/configuring-zed
    userSettings = {
      # assistant = {
      #   enabled = true;
      #   version = "2";
      #   default_open_ai_model = null;
      #   ### PROVIDER OPTIONS
      #   ### zed.dev models { claude-3-5-sonnet-latest } requires github connected
      #   ### anthropic models { claude-3-5-sonnet-latest claude-3-haiku-latest claude-3-opus-latest  } requires API_KEY
      #   ### copilot_chat models { gpt-4o gpt-4 gpt-3.5-turbo o1-preview } requires github connected
      #   default_model = {
      #     provider = "zed.dev";
      #     model = "claude-3-5-sonnet-latest";
      #   };
      # };

      node = {
        path = lib.getExe pkgs.nodejs;
        npm_path = lib.getExe' pkgs.nodejs "npm";
      };

      indent_guides = {
        enabled = true;
        coloring = "indent_aware";
        # background_coloring = "indent_aware";
      };

      collaboration_panel = {
        button = false;
        default_width = 300;
        dock = "right";
      };

      # Terminal
      # https://zed.dev/docs/configuring-zed#terminal
      terminal = {
        alternate_scroll = "off";
        blinking = "off";
        copy_on_select = true;
        dock = "bottom";
        detect_venv = {
          on = {
            directories = [
              ".env"
              "env"
              ".venv"
              "venv"
            ];
            activate_script = "default";
          };
        };
        env = {
          TERM = "xterm-256color";
        };
        font_family = "MesloLGS Nerd Font Mono";
        # font_features = null;
        font_size = lib.mkDefault 18;
        line_height = "comfortable";
        option_as_meta = false;
        button = true;
        shell = {
          program = "fish";
        };
        toolbar = {
          breadcrumbs = false;
        };
        working_directory = "current_project_directory";
      };

      # Language-specific
      # https://zed.dev/docs/configuring-languages
      languages = {
        Markdown = {
          # https://zed.dev/docs/languages/markdown
          format_on_save = "on";
        };
        Nix = {
          # https://github.com/oxalica/nil
          # https://github.com/nix-community/nixd
          tab_size = 2;
          language_servers = [
            "nil"
            "nixd"
          ];
          formatter = {
            external = {
              # https://github.com/NixOS/nixfmt
              command = "nixfmt";
            };
          };
          format_on_save = "on";
        };
        Python = {
          # https://github.com/python-lsp/python-lsp-server
          # https://github.com/microsoft/pyright
          tab_size = 4;
          language_servers = [
            "pylsp"
            "!pyright"
            "basedpyright"
          ];
          formatter = {
            external = {
              # https://github.com/astral-sh/ruff
              command = "ruff";
              arguments = [
                "format"
                "--stdin-filename"
                "{buffer_path}"
                "-"
              ];
            };
          };
          format_on_save = "on";
        };
      };

      # Language servers
      # https://zed.dev/docs/configuring-languages#configuring-language-servers
      lsp = {
        # https://github.com/oxalica/nil/blob/main/docs/configuration.md
        nil.initialization_options = {
          nix.flake.autoArchive = true;
        };
      };

      telemetry = {
        diagnostics = false;
        metrics = false;
      };

      git = {
        inline_blame = {
          enabled = true;
          delay_ms = 500;
        };
      };

      # theme = {
      #   mode = "dark";
      #   light = "One Light";
      #   # dark = "Nord";
      #   dark = "Catppuccin Macchiato";
      # };

      # icon_theme = {
      #   mode = "dark";
      #   light = "Catppuccin Latte";
      #   dark = "Catppuccin Macchiato";
      # };

      features = {
        # edit_prediction_provider = "zed";
        edit_prediction_provider = "copilot";
      };

      edit_predictions = {
        mode = "subtle";
      };

      ## tell zed to use direnv and direnv can use a flake.nix enviroment.
      load_direnv = "shell_hook";

      # editor settings
      base_keymap = "VSCode";
      hour_format = "hour24";
      auto_update = false;
      show_whitespaces = "all";
      ui_font_family = "Inter";
      ui_font_size = lib.mkDefault 19;
      buffer_font_family = "MesloLGS Nerd Font Mono";
      buffer_font_size = lib.mkDefault 18;
      always_treat_brackets_as_autoclosed = true;
      preferred_line_length = 120;
      soft_wrap = "preferred_line_length";
      remove_trailing_whitespace_on_save = true;
      ensure_final_newline_on_save = true;
      format_on_save = "on";
      tab_size = 4;

      # vim mode
      vim_mode = false;
      relative_line_numbers = false;
    };

    # User Keymaps
    # https://zed.dev/docs/key-bindings
    userKeymaps = [
      {
        context = "Workspace";
        bindings = {
          ctrl-shift-t = "workspace::NewTerminal";
        };
      }
      {
        context = "Editor && !menu";
        bindings = {
          ctrl-c = "editor::Copy";
          ctrl-v = "editor::Paste";
          ctrl-x = "editor::Cut";
          ctrl-z = "editor::Undo";
          ctrl-shift-z = "editor::Redo";
          # ctrl-f = "editor::Find";
          ctrl-a = "editor::SelectAll";
        };
      }
      {
        context = "VimControl && !menu";
        bindings = {
          m = "vim::Left";
          left = "vim::Left";
          i = "vim::Right";
          right = "vim::Right";
          e = "vim::Up";
          up = "vim::Up";
          n = "vim::Down";
          down = "vim::Down";
          tab = "vim::Tab";
          space = "vim::WrappingRight";
          l = "vim::InsertBefore";
        };
      }
    ];
  };
}
