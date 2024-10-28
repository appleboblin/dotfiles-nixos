{
    programs.nixvim = {
        plugins = {
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
                extensions.fzf-native = { enable = true; };
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
                autoReloadOnWrite = true;
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
                settings = { max_lines = 2; };
            };
            rainbow-delimiters.enable = true;
        };
    };
}
