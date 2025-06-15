{
  programs.foot = {
    enable = true;
    settings = {
      main = {
        term = "foot";
        font = "MesloLGS Nerd Font Mono:size=16";
        shell = "fish";
        pad = "8x8";
      };
      cursor = {
        style = "block";
        color = "2e3440 d8dee9";
        blink = "yes";
      };
      # colors = {
      # Nord
      #   alpha = "0.95";
      #   foreground = "d8dee9";
      #   background = "2e3440";

      #   # selection-foreground = "d8dee9";
      #   # selection-background = "4c566a";

      #   regular0 = "3b4252";
      #   regular1 = "bf616a";
      #   regular2 = "a3be8c";
      #   regular3 = "ebcb8b";
      #   regular4 = "81a1c1";
      #   regular5 = "b48ead";
      #   regular6 = "88c0d0";
      #   regular7 = "e5e9f0";

      #   bright0 = "4c566a";
      #   bright1 = "bf616a";
      #   bright2 = "a3be8c";
      #   bright3 = "ebcb8b";
      #   bright4 = "81a1c1";
      #   bright5 = "b48ead";
      #   bright6 = "8fbcbb";
      #   bright7 = "eceff4";

      #   dim0 = "373e4d";
      #   dim1 = "94545d";
      #   dim2 = "809575";
      #   dim3 = "b29e75";
      #   dim4 = "68809a";
      #   dim5 = "8c738c";
      #   dim6 = "6d96a5";
      #   dim7 = "aeb3bb";
      # };

      colors = {
        # Catppuccin Macchiato
        alpha = "0.95";
        foreground = "cad3f5"; # Text
        background = "24273a"; # Base

        # Uncomment these if you want selection customization
        # selection-foreground = "cad3f5";
        # selection-background = "5b6078";

        regular0 = "494d64"; # surface1
        regular1 = "ed8796"; # red
        regular2 = "a6da95"; # green
        regular3 = "eed49f"; # yellow
        regular4 = "8aadf4"; # blue
        regular5 = "f5bde6"; # pink
        regular6 = "8bd5ca"; # teal
        regular7 = "b8c0e0"; # subtext1

        bright0 = "5b6078"; # surface2
        bright1 = "ed8796"; # red
        bright2 = "a6da95"; # green
        bright3 = "eed49f"; # yellow
        bright4 = "8aadf4"; # blue
        bright5 = "f5bde6"; # pink
        bright6 = "8bd5ca"; # teal
        bright7 = "a5adcb"; # subtext0

        dim0 = "363a4f"; # custom dim (deeper surface0)
        dim1 = "b8586f"; # dim red
        dim2 = "7fb992"; # dim green
        dim3 = "c8aa79"; # dim yellow
        dim4 = "6c8ed6"; # dim blue
        dim5 = "d6a5cb"; # dim pink
        dim6 = "6bbdac"; # dim teal
        dim7 = "939ab7"; # dim subtext
      };

    };
  };
}
