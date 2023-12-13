{config, pkgs, lib, ...}:
{
  imports = [
    ./programs.nix
    ./term/wezterm.nix
  ];
}
