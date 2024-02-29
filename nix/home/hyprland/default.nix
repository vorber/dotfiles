{config, pkgs, lib, ...}:
{
  imports = [
      ./hyprland.nix
      ./waybar.nix
      ./rofi.nix
  ];
}
