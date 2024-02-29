{ config, pkgs, lib, ... }:
{
  programs.wezterm = {
    enable = true;
    enableBashIntegration = true;
    #enableFishIntegration = true;
    #todo: source/symlink config file
  };
}
