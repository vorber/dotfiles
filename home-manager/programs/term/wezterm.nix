{ config, pkgs, lib, ... }:
{
  programs.wezterm = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration =  true;
    #todo: source/symlink config file
  };
}
