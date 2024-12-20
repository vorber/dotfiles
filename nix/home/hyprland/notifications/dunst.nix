{ config, lib, pkgs, ... }:
let
  palette = config.colorScheme.palette;
in {
  services.dunst = {
    enable = true;
    
    iconTheme = {
      package = pkgs.papirus-icon-theme;
      name = "Papirus";
    };

    settings = {
      global = {
        follow = "none";
        width = 370;
        separator_height = 1;
        padding = 24;
        horizontal_padding = 24;
        frame_width = 1;
        sort = "update";
        idle_threshold = 120;
        alignment = "center";
        word_wrap = "yes";
        transparency = 5;
        format = "<b>%s</b>: %b";
        markup = "full";
        min_icon_size = 32;
        max_icon_size = 128;
        frame_color = "#${palette.base0D}";
        separator_color = "frame";
        corner_radius = 10;
        #highlight = "#${palette.base03}";
      };

      urgency_low = {
        foreground = "#${palette.base05}";
        background = "#${palette.base00}";
        #frame_color = "#${palette.base02}";
      };

      urgency_normal = {
        #frame_color = "#${palette.base02}";
        foreground = "#${palette.base05}";
        background = "#${palette.base00}";
      };

      urgency_critical = {
        foreground = "#${palette.base05}";
        background = "#${palette.base00}";
        frame_color = "#${palette.base09}";
      };
    };
  };
}
