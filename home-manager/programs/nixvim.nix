{
    config,
    pkgs,
    lib,
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
            telescope.enable = true;
            lsp = {
                enable = true;
                servers = {
                    tsserver.enable = true;
                    lua-ls.enable = true;
                    pyright.enable = true;
                };
            };
            nvim-cmp = {
                enable = true;
                autoEnableSources = true;
                sources = [
                    {name = "nvim_lsp";}
                    {name = "path";}
                    {name = "buffer";}
                ];
            };
        };
        options = {
            number = true;
            relativenumber = true;
            shiftwidth = 4;
        };
        keymaps = [
            # {
            #     key = "";
            #     action = "";
            # }
            {
                key = ";";
                action = ":";
            }
            {
                key = "m";
                action = "h";
            }
            {
                key = "n";
                action = "j";
            }
            {
                key = "e";
                action = "k";
            }
            {
                key = "i";
                action = "l";
            }
            {
                key = "u";
                action = "i";
            }
            {
                key = "U";
                action = "I";
            }
            {
                key = "l";
                action = "u";
            }
        ];
        highlight = {
            Comment.fg = "#ff00ff";
            COmment.bg = "#000000";
            Comment.underline = true;
            Comment.bold = true;
        };
    };
}
