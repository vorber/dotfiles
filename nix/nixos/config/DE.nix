{pkgs, inputs, ...}:
{
  services.xserver = {
    # Enable the X11 windowing system.
    enable = true;

    # Enable the GNOME Desktop Environment.
    displayManager.gdm.enable = true;
    displayManager.gdm.wayland = true;
    desktopManager.gnome.enable = true;

    # Configure keymap in X11
    xkb.layout = "us,ru";
    xkb.options = "eurosign:e,caps:escape";
    videoDrivers = ["amdgpu"];
  };

  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages."${pkgs.system}".hyprland;
    xwayland.enable = true;
  };

  environment.systemPackages = with pkgs; [
    dunst #or mako?
    libnotify
    swww
    #rofi-wayland
    wofi
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
