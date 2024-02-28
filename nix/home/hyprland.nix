{ config, pkgs, lib, ... }:
{
  config = lib.mkIf config.isNixOS {
    home.packages = [pkgs.variety];
    wayland.windowManager.hyprland = {
      enable = true;
      xwayland.enable = true;
      systemd.enable = true;

      plugins = [

      ];

      settings = 
      let
        startupScript = lib.writeShellScriptBin "start" ''
          ${pkgs.waybar}/bin/waybar &
          ${pkgs.swww}/bin/swww init &
      
          sleep 1
      
          ${pkgs.swww}/bin/swww img ${./wallpaper.png} &          
        '';
      in
      {
        exec-once = ''${startupScript}/bin/start'';

        "$mod" = "SUPER";

        monitor = [
          ",preferred,auto,1"
        ];

        general = {
          layout = "dwindle";
          resize_on_border = true;
        };

        input = {
          kb_layout = "us";
          follow_mouse = 1;
          sensitivity = 0;
          #float_switch_override_focus = 2;
        };

        dwindle = {
          pseudotile = "yes";
          preserve_split = "yes";
          # no_gaps_when_only = "yes";
        };

        decoration = {
          drop_shadow = "yes";
          shadow_range = 8;
          shadow_render_power = 2;
          "col.shadow" = "rgba(00000044)";

          dim_inactive = false;

          blur = {
            enabled = true;
            size = 8;
            passes = 3;
            new_optimizations = "on";
            noise = 0.01;
            contrast = 0.9;
            brightness = 0.8;
            popups = true;
          };
        };

        animations = {
          enabled = "yes";
          bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
          animation = [
            "windows, 1, 5, myBezier"
            "windowsOut, 1, 7, default, popin 80%"
            "border, 1, 10, default"
            "fade, 1, 7, default"
            "workspaces, 1, 6, default"
          ];
        };

        bind = [
          "$mod, T, exec, wezterm"
          "$mod, Return, exec, wezterm"
          "$mod, D, exec, rofi -show drun"
          "$mod, T, exec, firefox"
          "$mod, Q, killactive"
          "$mod SHIFT, F, togglefloating"
          "$mod CTRL, F, fullscreen, 0"
          "$mod, P, togglesplit"
          "ALT, Tab, focuscurrentorlast"
          "$mod, Tab, cyclenext"
          "$mod, Tab, bringactivetotop"
          "$mod, mouse_down, workspace, e-1"
          "$mod, mouse_up, workspace, e+1"
          "$mod, left, movefocus, l"
          "$mod, right, movefocus, r"
          "$mod, up, movefocus, u"
          "$mod, down, movefocus, d"
          "$mod, 1, workspace, 1"
          "$mod, 2, workspace, 2"
          "$mod, 3, workspace, 3"
          "$mod, 4, workspace, 4"
          "$mod, 5, workspace, 5"
          "$mod, 6, workspace, 6"
          "$mod, 7, workspace, 7"
          "$mod, 8, workspace, 8"
          "$mod, 9, workspace, 9"
          "$mod, 0, workspace, 10"
          "$mod SHIFT, 1, movetoworkspace, 1"
          "$mod SHIFT, 2, movetoworkspace, 2"
          "$mod SHIFT, 3, movetoworkspace, 3"
          "$mod SHIFT, 4, movetoworkspace, 4"
          "$mod SHIFT, 5, movetoworkspace, 5"
          "$mod SHIFT, 6, movetoworkspace, 6"
          "$mod SHIFT, 7, movetoworkspace, 7"
          "$mod SHIFT, 8, movetoworkspace, 8"
          "$mod SHIFT, 9, movetoworkspace, 9"
          "$mod SHIFT, 0, movetoworkspace, 10"
        ];
        bindm = [
          "$mod, mouse:273, resizewindow"
          "$mod, mouse:272, movewindow"
        ];

      };
    };
  };
}