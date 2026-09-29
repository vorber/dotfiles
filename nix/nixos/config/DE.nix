{pkgs, inputs, config, ...}:
{
  services.desktopManager.gnome.enable = true;
  services.displayManager.gdm.enable = true;
  services.xserver = {
    # Enable the X11 windowing system.
    enable = true;

    # Configure keymap in X11
    xkb.layout = "us,ru";
    xkb.options = "eurosign:e,caps:escape";
    videoDrivers = ["amdgpu"];
  };

  nix.settings = {
    substituters = ["https://hyprland.cachix.org"];
    trusted-substituters = ["https://hyprland.cachix.org"];
    trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
  };

  programs.hyprland = let
    hyprlandPkgs = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system};
  in {
    enable = true;
    withUWSM = true;
    package = hyprlandPkgs.hyprland;
    portalPackage = hyprlandPkgs.xdg-desktop-portal-hyprland;
    xwayland.enable = true;
  };

  # withUWSM only enables UWSM; the "(uwsm-managed)" session shipped inside the
  # Hyprland package (`uwsm start ... hyprland.desktop`) hangs on a grey screen
  # under GDM. Register a NixOS-generated entry instead. binPath is the
  # start-hyprland watchdog (passes --watchdog-fd and restarts Hyprland in safe
  # mode after a crash); running Hyprland directly triggers a warning.
  # Named "hyprland-nixos" to avoid clashing with the package's
  # hyprland-uwsm.desktop; pick "Hyprland NixOS (UWSM)" in GDM.
  programs.uwsm.waylandCompositors.hyprland-nixos = {
    prettyName = "Hyprland NixOS";
    comment = "Hyprland compositor managed by UWSM";
    binPath = "/run/current-system/sw/bin/start-hyprland";
  };

  environment.systemPackages = with pkgs; [
    dunst #swaynotificationcenter #or dunst? #or mako?
    libnotify
    awww
    networkmanagerapplet
  ];
}
