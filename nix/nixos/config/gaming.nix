{ pkgs, ... }: {
#TODO: check args and toggle based on that
  programs.steam.enable = true; #TODO: can I get rid of it and use it through flake/hm?
  programs.gamemode.enable = true;
  programs.steam.extraCompatPackages = with pkgs; [
    proton-ge-bin
  ];
  environment.systemPackages = with pkgs; [
    protonup-qt
  ];
}
