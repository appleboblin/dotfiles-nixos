{
  pkgs,
  lib,
  ...
}:
{
  programs.zed-editor = {
    enable = true;
    package = pkgs.zed-editor-fhs;
    extensions = [
      "html"
      "toml"
      "nix"
      # "ron"
      "git-firefly"
      "ruff"
      "python-lsp"
      "fish"
      "rainbow-csv"
    ];

    extraPackages = with pkgs; [
      # nix
      nixd
      nil
      # alejandra
      nixfmt-rfc-style
      # python
      ruff
      pyright
      python3Packages.python-lsp-server
    ];

    ## everything inside of these brackets are Zed options.
    userSettings = {
      assistant = {
        enabled = true;
        version = "2";
        default_open_ai_model = null;
        ### PROVIDER OPTIONS
        ### zed.dev models { claude-3-5-sonnet-latest } requires github connected
        ### anthropic models { claude-3-5-sonnet-latest claude-3-haiku-latest claude-3-opus-latest  } requires API_KEY
        ### copilot_chat models { gpt-4o gpt-4 gpt-3.5-turbo o1-preview } requires github connected
        default_model = {
          provider = "zed.dev";
          model = "claude-3-5-sonnet-latest";
        };
      };

      node = {
        path = lib.getExe pkgs.nodejs;
        npm_path = lib.getExe' pkgs.nodejs "npm";
      };

      indent_guides = {
        enabled = true;
        coloring = "indent_aware";
        # background_coloring = "indent_aware";
      };

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
        font_size = 18;
        line_height = "comfortable";
        preferred_line_length = 120;
        remove_trailing_whitespace = true;
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

      languages = {
        Nix = {
          tab_size = 2;
          language_servers = [
            "nil"
            "nixd"
          ];
          formatter = {
            external = {
              command = "nixfmt";
            };
          };
          format_on_save = "on";
        };
        Python = {
          tab_size = 4;
          language_servers = [
            "pylsp"
            "pyright"
          ];
          formatter = {
            external = {
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

      lsp = {
        nil = {
          flake = {
            autoArchive = true;
          };
        };
      };

      telemetry = {
        diagnostics = false;
        metrics = false;
      };

      theme = {
        mode = "system";
        light = "One Light";
        dark = "Nord";
      };

      features = {
        edit_prediction_provider = "zed";
      };

      ## tell zed to use direnv and direnv can use a flake.nix enviroment.
      load_direnv = "shell_hook";
      base_keymap = "VSCode";
      hour_format = "hour24";
      auto_update = false;
      show_whitespaces = "all";
      ui_font_family = "Inter";
      ui_font_size = 19;
      buffer_font_family = "MesloLGS Nerd Font Mono";
      buffer_font_size = 18;

      # vim mode
      vim_mode = false;
      relative_line_numbers = true;
    };

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
          space = "vim::Space";
          l = "vim::InsertBefore";
        };
      }
    ];
  };
}
