{pkgs ? import <nixpkgs> {}}:
pkgs.mkShell {
  #nativeBuildInputs = with pkgs; [];  # only needed for developing nix/nixos
  buildInputs = with pkgs; [
    # common build inputs
    direnv
    gcc
    ];
  shellHook = ''
    #import parent shell config
    [ -x ~/.bashrc ] && source ~/.bashrc
    [ -x ~/.zshrc ] && source ~/.zshrc
  '';
}
