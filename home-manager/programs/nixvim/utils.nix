{
  lib,
  pkgs,
  ...
}:
{
  programs.nixvim = {
    dependencies = {
      typst.enable = true;
      tinymist.enable = true;
      websocat.enable = true;
    };
    lsp.inlayHints.enable = true;
    extraConfigLua = ''
      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*.typ",
        callback = function()
          vim.lsp.buf.format({ async = false })
        end,
      })
    '';
    plugins = {
      typst-preview.enable = true;
      # typst-vim.enable = true;
      # lsp-format.enable = true;
      lsp = {
        enable = true;
        keymaps.lspBuf = {
          gd = "definition";
          K = "hover";
        };
      };
      lsp.servers.tinymist = {
        enable = true;
        settings = {
          exportPdf = "onType";
          outputPath = "$root/$name";
          fontPaths = [ "./fonts" ];
          formatterMode = "typstyle";
        };
      };
      conform-nvim.settings = {
        formatters_by_ft.typst = [ "typstyle" ];
        formatters.typstyle.command = lib.getExe' pkgs.typstyle "typstyle";
      };

      lualine.enable = true;
      lazygit.enable = true;
      bufferline.enable = true;
      barbecue.enable = true;
      which-key.enable = true;
      nvim-autopairs.enable = true;
      copilot-chat.enable = true;
      trouble.enable = true;
      telescope = {
        enable = true;
        keymaps = {
          "<leader>fg" = "live_grep";
          "<C-p>" = {
            action = "git_files";
            options = {
              desc = "Telescope Git Files";
            };
          };
        };
        extensions.fzf-native = {
          enable = true;
        };
      };
      gitsigns = {
        enable = true;
        settings = {
          current_line_blame = true;
          trouble = true;
        };
      };
      toggleterm = {
        enable = true;
        settings = {
          open_mapping = "[[<C-t>]]";
        };
      };
      nvim-tree = {
        enable = true;
        openOnSetupFile = true;
        settings.auto_reload_on_write = true;
      };
      wilder = {
        enable = true;
        settings.modes = [
          ":"
          "/"
          "?"
        ];
      };
      auto-save = {
        enable = true;
        settings.enabled = true;
      };
      indent-blankline = {
        enable = true;
        settings = {
          indent = {
            smart_indent_cap = true;
            char = " ";
          };
          scope = {
            enabled = true;
            char = "│";
          };
        };
      };
      treesitter = {
        enable = true;
        nixGrammars = true;
        settings = {
          highlight.enable = true;
          indent.enable = true;
        };
      };
      treesitter-context = {
        enable = true;
        settings = {
          max_lines = 2;
        };
      };
      rainbow-delimiters.enable = true;
    };
  };
}
