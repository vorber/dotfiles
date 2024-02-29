{config, pkgs, lib, ...}:
let
  hypr = {
    "enabled" = [
      (import ./hyprland.nix)
      (import ./waybar.nix)
      (import ./rofi.nix)
    ];
    "disabled" = [];
  };
  setting = if config.isNixOS then "enabled" else "disabled";
in
{
  imports = [
  ] ++ (hypr.${setting} or []);
}
