{
    programs.nixvim = {
        keymaps = [
            # Rebind to Colemak DH
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

        ];
    };
}
