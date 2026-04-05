{ config, pkgs, ... }:
let
  palette = config.colorScheme.palette;
in
{
  programs.hyprlock = {
    enable = true;
    settings = {
      general.ignore-empty-input = false;
      general.immediate_render = true;
      background = [{
        path = "~/Pictures/wallpaper.png";
        blur_passes = 3;
        blur_size = 8;
      }];
      # shape = [
      #   {
      #     size = "360, 60";
      #     rounding = -1;
      #     color = "rgba(0,0,0,0.0)";
      #     border_color = "0xff${palette.base07}";
      #     border_size = 4;
      #     position = "0, 80";
      #     halign = "center";
      #     valign = "center";
      #   }
      # ];
      input-field = [
        {
          size = "200, 50";
          position = "0, 0";
          dots_center = true;
          fade_on_empty = false;
          outline_thickness = 5;
          shadow_passes = 1;
          outer_color = "0xff${palette.base07}";
          inner_color = "0xff${palette.base00}";
          font_color = "0xff${palette.base05}";
        }
      ];
    };
  };
}
