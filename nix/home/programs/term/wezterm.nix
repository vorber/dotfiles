{ config, pkgs, lib, ... }:
let
  extraConfig = builtins.readFile ./wezterm.lua;
in
{
  programs.wezterm = {
    enable = true;
    enableBashIntegration = true;
    #enableFishIntegration = true;
    inherit extraConfig;
  };
}
