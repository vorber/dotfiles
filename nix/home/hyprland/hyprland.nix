{ pkgs, launcher, ... }:
{
  home.packages = [pkgs.variety];
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    systemd.enable = true;

    plugins = [

    ];

    settings = 
    let
      startupScript = pkgs.writeShellScriptBin "start" ''
        ${pkgs.waybar}/bin/waybar &
        ${pkgs.swww}/bin/swww init &
    
        sleep 1
    
        ${pkgs.swww}/bin/swww img ~/Pictures/wallpaper.png &          
      '';
    in
    {
      exec-once = ''${startupScript}/bin/start'';

      "$mod" = "SUPER";

      monitor = [
#LG Electronics LG HDR 4K 0x00006F1B
#Ancor Communications Inc ASUS VS247 G8LMTF096313
        "desc:Ancor Communications Inc ASUS VS247 G8LMTF096313, preferred, 0x240, 1"
        "desc:LG Electronics LG HDR 4K 0x00006F1B, preferred, 1920x0, 2"
        ",preferred,auto,1"
      ];

      workspace = [
        "1,monitor:desc:Ancor Communications Inc ASUS VS247 G8LMTF096313,default:true,persistent:true,on-created-empty:firefox"
        "2,monitor:desc:LG Electronics LG HDR 4K 0x00006F1B,default:true,persistent:true,on-created-empty:wezterm"
      ];

      general = {
        layout = "dwindle";
        border_size = 3;
        gaps_in = 5;
        gaps_out = 0;
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
        no_gaps_when_only = "yes";
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
      windowrule = [
            "float, ^(steam)$"
            "tile,title:^(WPS)(.*)$"
            # Dialogs
            "float,title:^(Open File)(.*)$"
            "float,title:^(Open Folder)(.*)$"
            "float,title:^(Save As)(.*)$"
            "float,title:^(Library)(.*)$"
            "float,title:^(xdg-desktop-portal)(.*)$"
            "nofocus,title:^(.*)(mvi)$"
          ];

      layerrule = [
        "blur, ^(wlogout)"
        "blur, gtk-layer-shell"
      ];

      bind = [
        "$mod, T, exec, wezterm"
        "$mod, Return, exec, wezterm -e tmux"
        "$mod, R, exec, ${launcher}"
        "$mod, G, exec, ${launcher}"
        "$mod, B, exec, firefox"
        "$mod, Q, killactive"
        "$mod SHIFT, F, togglefloating"
        "$mod, F, fullscreen, 0"
        "$mod, P, togglesplit"
        "ALT, Tab, focuscurrentorlast"
        "$mod, Tab, cyclenext"
        "$mod, Tab, bringactivetotop"
        "$mod, mouse_down, workspace, e-1"
        "$mod, mouse_up, workspace, e+1"
        "$mod SHIFT, left, workspace, e-1"
        "$mod SHIFT, right, workspace, e+1"
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
        ", XF86AudioRaiseVolume, exec, wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+"
        ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"

      ];
      bindm = [
        "$mod, mouse:273, resizewindow"
        "$mod, mouse:272, movewindow"
      ];

    };
  };
}
