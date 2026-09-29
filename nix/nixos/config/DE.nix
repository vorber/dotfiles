{pkgs, lib, inputs, config, ...}:
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
  # under GDM, so register our own entry:
  # - start-hyprland is the watchdog (passes --watchdog-fd, restarts Hyprland in
  #   safe mode after a crash); running Hyprland directly triggers a warning.
  # - -e -D Hyprland: otherwise uwsm derives XDG_CURRENT_DESKTOP from the binary
  #   name ("start-hyprland"), which Hyprland warns about and which breaks
  #   xdg.portal.config.hyprland portal selection.
  # programs.uwsm.waylandCompositors can't express this (its extraArgs go to the
  # compositor, after `--`). Named "hyprland-nixos" to avoid clashing with the
  # package's hyprland-uwsm.desktop; pick "Hyprland NixOS (UWSM)" in GDM.
  services.displayManager.sessionPackages = [
    (pkgs.writeTextFile {
      name = "hyprland-nixos-uwsm";
      destination = "/share/wayland-sessions/hyprland-nixos-uwsm.desktop";
      derivationArgs.passthru.providedSessions = [ "hyprland-nixos-uwsm" ];
      text = ''
        [Desktop Entry]
        Name=Hyprland NixOS (UWSM)
        Comment=Hyprland compositor managed by UWSM
        Exec=${lib.getExe config.programs.uwsm.package} start -F -e -D Hyprland -- /run/current-system/sw/bin/start-hyprland
        DesktopNames=Hyprland
        Type=Application
      '';
    })
  ];

  environment.systemPackages = with pkgs; [
    dunst #swaynotificationcenter #or dunst? #or mako?
    libnotify
    awww
    networkmanagerapplet
  ];
}
