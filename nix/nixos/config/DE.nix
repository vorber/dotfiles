{pkgs, inputs, ...}:
{
  services.desktopManager.gnome.enable = true;
  services.displayManager.gdm.wayland = true;
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

  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages."${pkgs.system}".hyprland;
    xwayland.enable = true;
  };
#needed for swaylock to work, see https://nix-community.github.io/home-manager/options.xhtml#opt-programs.swaylock.enable
  security.pam.services.swaylock = {};
  environment.systemPackages = with pkgs; [
    dunst #swaynotificationcenter #or dunst? #or mako?
    libnotify
    swww
    networkmanagerapplet
  ];

  xdg.portal = {
    enable = true;
    extraPortals = [
#TODO: check others
      #pkgs.xdg-desktop-portal-gtk

    ];
  };
}
