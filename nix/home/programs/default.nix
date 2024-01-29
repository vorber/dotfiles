{config, pkgs, lib, ...}:
{
  imports = [
    ./programs.nix
    ./games.nix
    ./nvim
    ./tmux.nix
# nix   ./term/wezterm.nix
  ];
}
