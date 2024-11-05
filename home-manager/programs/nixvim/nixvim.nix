{
    inputs,
    ...
}: {
    imports = [
        inputs.nixvim.homeManagerModules.nixvim
    ];
    programs.nixvim = {
        enable = true;
        colorschemes.nord.enable = true;
        plugins = {
            lualine.enable = true;
            treesitter.enable = true;
            lazygit.enable = true;
            # neo-tree.enable = true;
            nvim-tree.enable = true;
            bufferline.enable = true;
            barbecue.enable = true;
            which-key.enable = true;
            nvim-autopairs.enable = true;
            # web-devicons.enable = true;
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
                extensions.fzf-native = { enable = true; };
            };
            toggleterm = {
                enable = true;
                settings = {
                    open_mapping = "[[<C-t>]]";
                };
            };
            wilder = {
                enable = true;
                modes = [ ":" "/" "?" ];
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
            # cmp.enable = true;
            # cmp-buffer.enable = true;
            # cmp-nvim-lsp.enable = true;
            # cmp-path.enable = true;
            # lsp = {
            #     enable = true;
            #     servers = {
            #         ts_ls.enable = true;
            #         lua_ls.enable = true;
            #         pyright.enable = true;
            #     };
            # };
        };
        opts = {
            number = true;
            relativenumber = true;
            shiftwidth = 4;
            clipboard = "unnamedplus";
        };
        globals.mapleader = " ";
        keymaps = [
            # { key = ""; action = ""; }
            # Movements
            { key = ";"; action = ":"; }
            { key = "m"; action = "h"; }
            { key = "n"; action = "j"; }
            { key = "e"; action = "k"; }
            { key = "i"; action = "l"; }
            { key = "M"; action = "H"; }
            { key = "N"; action = "J"; }
            { key = "E"; action = "K"; }
            { key = "I"; action = "L"; }

            # Words forward/backward
            # j/J = end of word/WORD
            { key = "j"; action = "e"; }
            { key = "J"; action = "E"; }

            #insert
            { key = "l"; action = "i"; }
            { key = "L"; action = "I"; }

            # Search
            { key = "k"; action = "n"; }
            { key = "K"; action = "N"; }

            # Mark
            { key = "h"; action = "m"; }
            { key = "H"; action = "M"; }

            # Matching pairs
            # { key = "("; action = "()<Left>"; mode = "i"; }
            # { key = "["; action = "[]<Left>"; mode = "i"; }
            # { key = "{"; action = "{}<Left>"; mode = "i"; }
            # { key = "'"; action = "''<Left>"; mode = "i"; }
            # { key = "\""; action = "\"\"<Left>"; mode = "i"; }
            # { key = "`"; action = "``<Left>"; mode = "i"; }

            # Commands
            { key = "<S-Z>"; action = "<cmd>:NvimTreeToggle<CR>"; }
            # { key = "<S-Z>"; action = "<cmd>:Neotree<CR>"; }
            { key = "<S-m>"; action = "<cmd>:bprev<CR>"; }
            { key = "<S-i>"; action = "<cmd>:bnext<CR>"; }
        ];
        highlight = {
            Comment.fg = "#ff00ff";
            COmment.bg = "#000000";
            Comment.underline = true;
            Comment.bold = true;
        };
    };
}
