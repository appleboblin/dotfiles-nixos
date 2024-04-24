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
            # neo-tree.enable = true;
            nvim-tree.enable = true;
            bufferline.enable = true;
            barbecue.enable = true;
            which-key.enable = true;
            cmp.enable = true;
            cmp-buffer.enable = true;
            cmp-nvim-lsp.enable = true;
            cmp-path.enable = true;
            lsp = {
                enable = true;
                servers = {
                    tsserver.enable = true;
                    lua-ls.enable = true;
                    pyright.enable = true;
                };
            };
        };
        opts = {
            number = true;
            relativenumber = true;
            shiftwidth = 4;
        };
        globals.mapleader = ",";
        keymaps = [
            # { key = ""; action = ""; }
            { key = ";"; action = ":"; }
            { key = "m"; action = "h"; }
            { key = "n"; action = "j"; }
            { key = "e"; action = "k"; }
            { key = "i"; action = "l"; }
            { key = "u"; action = "i"; }
            { key = "U"; action = "I"; }
            { key = "l"; action = "u"; }
            { key = "k"; action = "n"; }
            { key = "K"; action = "N"; }
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
