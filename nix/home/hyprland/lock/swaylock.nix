{ config, lib, pkgs, ... }:
{
  #home.packages = [
  #  pkgs.swaylock-effects
  #];

  programs.swaylock = {
    enable = true;
    package = pkgs.swaylock-effects;
    settings = {
      image = "~/Pictures/wallpaper.png";
      clock = true;
      grace = 30;
      color = "808080";
      font-size = 24;
      indicator = true;
      indicator-radius = 220;
      indicator-thickness = 25;
      indicator-idle-visible = false;
      line-color = "ffffff";
      show-failed-attempts = true;     
      fade-in = "0.5";
    };
  };
}
