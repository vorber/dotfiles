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
  # Hyprland package runs `uwsm start ... hyprland.desktop` (via start-hyprland)
  # and hangs on a grey screen under GDM. Register the NixOS-generated entry,
  # which execs the binary directly (same as `uwsm start -F -- Hyprland` from a
  # TTY, which works). Named "hyprland-nixos" to avoid clashing with the
  # package's hyprland-uwsm.desktop; pick "Hyprland NixOS (UWSM)" in GDM.
  programs.uwsm.waylandCompositors.hyprland-nixos = {
    prettyName = "Hyprland NixOS";
    comment = "Hyprland compositor managed by UWSM";
    binPath = "/run/current-system/sw/bin/Hyprland";
  };

  environment.systemPackages = with pkgs; [
    dunst #swaynotificationcenter #or dunst? #or mako?
    libnotify
    awww
    networkmanagerapplet
  ];
}
