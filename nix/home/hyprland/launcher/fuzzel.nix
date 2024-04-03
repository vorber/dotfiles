{ config, pkgs, lib, inputs, ... }:
let
  palette = config.colorScheme.palette;
in
{
  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        terminal = "${pkgs.alacritty}/bin/alacritty";
        layer = "overlay";
        font = "MesloLGMNerdFontMono:size=14";
        dpi-aware = "yes";
      };
      dmenu = {
        exit-immediately-if-empty="yes";
      };
      border = {
        width = 1;
      };
      colors = {
        background="${palette.base00}dd";
        text="${palette.base05}ff";
        match="${palette.base08}ff";
        selection="${palette.base04}ff";
        selection-match="${palette.base08}ff";
        selection-text="${palette.base05}ff";
        border="${palette.base07}ff";
      };
    };
  };
}
