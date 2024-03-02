{config, pkgs, lib, ...}:
{
  imports = [
      ./hyprland.nix
      ./wlogout.nix
      ./waybar.nix
      ./launcher/wofi.nix
  ];
}
