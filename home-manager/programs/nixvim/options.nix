{
    programs.nixvim = {
        opts = {
            updatetime = 100; # Faster completion

            number = true;
            relativenumber = true;
            splitbelow = true;
            splitright = true;
            scrolloff = 4;

            autoindent = true;
            clipboard = "unnamedplus";
            expandtab = true;
            shiftwidth = 4;
            smartindent = true;
            tabstop = 4;

            ignorecase = true;
            incsearch = true;
            smartcase = true;
            wildmode = "list:longest";

            swapfile = false;
            undofile = true; # Build-in persistent undo
        };
    };
}