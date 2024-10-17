{ config, pkgs, ... }:
let
  palette = config.colorScheme.palette;
in
{
  #home.packages = [
  #  pkgs.swaylock-effects
  #];

  programs.swaylock = {
    enable = true;
    package = pkgs.swaylock-effects;
    settings = {
      timestr = "%R";
      datestr = "%a, %b %e";
      show-keyboard-layout = true;
      image = "~/Pictures/wallpaper.png";
      clock = true;
      grace = 30;
      #font-size = 24;
      indicator = true;
      indicator-radius = 300;
      indicator-thickness = 25;
      indicator-caps-lock = true;
      indicator-idle-visible = false;
      show-failed-attempts = true;     
      fade-in = "0.5";
      ignore-empty-password = true;

      effect-blur = "20x6";

      color="${palette.base00}";
      bs-hl-color="${palette.base06}";
      caps-lock-bs-hl-color="${palette.base06}";
      caps-lock-key-hl-color="${palette.base0B}";
      inside-color="00000000";
      inside-clear-color="00000000";
      inside-caps-lock-color="00000000";
      inside-ver-color="00000000";
      inside-wrong-color="00000000";
      key-hl-color="${palette.base0B}";
      layout-bg-color="00000000";
      layout-border-color="00000000";
      layout-text-color="${palette.base05}";
      line-color="00000000";
      line-clear-color="00000000";
      line-caps-lock-color="00000000";
      line-ver-color="00000000";
      line-wrong-color="00000000";
      ring-color="${palette.base07}";
      ring-clear-color="${palette.base06}";
      ring-caps-lock-color="${palette.base09}";
      ring-ver-color="${palette.base0D}";
      ring-wrong-color="ea999c";
      separator-color="00000000";
      text-color="${palette.base05}";
      text-clear-color="${palette.base06}";
      text-caps-lock-color="${palette.base09}";
      text-ver-color="${palette.base0D}";
      text-wrong-color="ea999c";
    };
  };
}
