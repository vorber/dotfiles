{config, pkgs, lib, ...}:
{
  imports = [
    ./programs.nix
    ./shell
    ./games.nix
    ./nvim
    ./tmux.nix
# nix   ./term/wezterm.nix
  ];
}
