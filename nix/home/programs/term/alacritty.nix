{ config, ...}:
let
  palette = config.colorScheme.palette;
in
{
  programs.alacritty = {
    enable = true;
    settings = {
      general = {
        live_config_reload = true;
      };
      window = {
        opacity = 0.75;
        blur = true;
      };
      scrolling.history = 100000;
      font = {
        normal.family = "JetBrainsMono Nerd Font";#"Meslo LGS NF";
        bold = { style = "Bold"; };
        size = 11;
      };
#      colors = {
#        primary = {
#          background = "#303446";
#          foreground = "#C6D0F5";
#          dim_foreground = "#C6D0F5";
#          bright_foreground = "#C6D0F5";         
#        };
#      };
    };
  };
}
