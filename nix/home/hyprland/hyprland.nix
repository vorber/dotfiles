{ pkgs, lib, inputs, launcher, ... }:
let
  terminal = "alacritty";
  hyprlandPkgs = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system};

  # Render a Nix value as a Lua literal, so interpolated strings are quoted safely.
  lua = lib.generators.toLua { };

  samsung = "desc:Samsung Electric Company Odyssey G80SD H1AK500000";
  lg = "desc:LG Electronics LG HDR 4K 0x00006F1B";
  #asus = "desc:Ancor Communications Inc ASUS VS247 G8LMTF096313";

  startupScript = pkgs.writeShellScriptBin "start" ''
    ${pkgs.waybar}/bin/waybar &
    ${pkgs.awww}/bin/awww-daemon &

    sleep 1

    ${pkgs.awww}/bin/awww img ~/Pictures/wallpaper.png &
  '';
in
{
  home.packages = [pkgs.variety];

  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-wlr
    ];
    xdgOpenUsePortal = true;
    config.hyprland = {
      default = [ "hyprland" "gtk" ];
      "org.freedesktop.impl.portal.FileChooser" = "gtk";
      "org.freedesktop.impl.portal.Print" = "gtk";
    };
  };
  wayland.windowManager.hyprland = {
    enable = true;
    # Keep in lockstep with programs.hyprland.package (nixos/config/DE.nix);
    # otherwise hyprctl, the reload hook and the Lua stubs come from nixpkgs.
    package = hyprlandPkgs.hyprland;
    portalPackage = hyprlandPkgs.xdg-desktop-portal-hyprland;
    xwayland.enable = true;
    systemd.enable = true;

    # Hyprland >= 0.55 reads hyprland.lua; the hyprlang (hyprland.conf) parser
    # has since been removed. home.stateVersion < 26.05 still defaults to
    # "hyprlang", so this must be set explicitly.
    configType = "lua";

    plugins = [

    ];

    # Each attribute renders as hl.<name>(...); list values render one call per element.
    settings = {
      config = {
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

        # dwindle.pseudotile was removed upstream (pseudotiling is now just the
        # hl.dsp.window.pseudo() dispatcher). no_gaps_when_only was removed too;
        # the w[tv1] / f[1] workspace + window rules below replace it.
        dwindle = {
          preserve_split = true;
        };

        decoration = {
          #TODO: figure out
          # shadow = {
          #   enabled = true;
          #   range = 8;
          #   render_power = 2;
          #   color = "rgba(00000044)";
          # };

          dim_inactive = false;

          blur = {
            enabled = true;
            size = 8;
            passes = 3;
            new_optimizations = true;
            noise = 0.01;
            contrast = 0.9;
            brightness = 0.8;
            popups = true;
          };
        };

        animations.enabled = true;
      };

      curve = {
        _args = [ "myBezier" { type = "bezier"; points = [ [ 0.05 0.9 ] [ 0.1 1.05 ] ]; } ];
      };

      animation = [
        { leaf = "windows";    enabled = true; speed = 5;  bezier = "myBezier"; }
        { leaf = "windowsOut"; enabled = true; speed = 7;  bezier = "default"; style = "popin 80%"; }
        { leaf = "border";     enabled = true; speed = 10; bezier = "default"; }
        { leaf = "fade";       enabled = true; speed = 7;  bezier = "default"; }
        { leaf = "workspaces"; enabled = true; speed = 6;  bezier = "default"; }
      ];

      monitor = [
        #{ output = asus; mode = "preferred"; position = "0x240"; scale = 1; }
        { output = samsung; mode = "preferred"; position = "1920x0"; scale = 2; }
        { output = lg;      mode = "preferred"; position = "0x0";    scale = 2; }
        { output = "";      mode = "preferred"; position = "auto";   scale = 1; }
      ];

      workspace_rule = [
        #{ workspace = "1"; monitor = asus; default = true; persistent = true; on_created_empty = "firefox"; }
        { workspace = "1"; monitor = samsung; default = true; persistent = true; on_created_empty = "firefox"; }
        { workspace = "9"; monitor = samsung; default = true; persistent = true; on_created_empty = "telegram-desktop"; }
        { workspace = "2"; monitor = lg;      default = true; persistent = true; on_created_empty = "${terminal} -e tmux a"; }
        { workspace = "special:pass"; on_created_empty = "KeePassXC"; persistent = true; }
        { workspace = "w[tv1]"; gaps_out = 0; gaps_in = 0; }
        { workspace = "f[1]";   gaps_out = 0; gaps_in = 0; }
      ];

      # match.* fields are RE2 regexes (full match); prefix with "negative:" to invert.
      window_rule = [
        #Misc
        { match.title = "^(WPS)(.*)$"; tile = true; }
        # Dialogs
        { match.modal = true; float = true; }
        # { match.title = "^(Open File)(.*)$"; float = true; }
        # { match.title = "^(Open Folder)(.*)$"; float = true; }
        # { match.title = "^(Save As)(.*)$"; float = true; }
        { match.title = "^(Library)(.*)$"; float = true; }
        { match.title = "^(xdg-desktop-portal)(.*)$"; float = true; }
        { match.title = "^(.*)(mvi)$"; no_focus = true; }
        { match.title = "^(Exiled Exchange 2)$"; float = true; }
        { match.class = "^org.keepassxc.KeePassXC$"; float = true; }
        { match.class = "^org.keepassxc.KeePassXC$"; workspace = "special:pass silent"; }
        { match.class = "^(steam)$"; workspace = "10 silent"; }
        { match.class = "^(steam)$"; tile = true; }
        { match = { class = "^(steam)$"; title = "negative:.*Steam Settings.*"; }; stay_focused = true; }
        { match.class = "^(org.telegram.desktop)$"; workspace = "9 silent"; }

        { match = { float = false; workspace = "w[tv1]"; }; border_size = 0; rounding = 0; }
        { match = { float = false; workspace = "f[1]"; };   border_size = 0; rounding = 0; }
      ];

      layer_rule = [
        { match.namespace = "^(wlogout)"; blur = true; }
        { match.namespace = "gtk-layer-shell"; blur = true; }
      ];
    };

    # Autostart and binds are plain Lua: dispatchers are Lua values, and the
    # numbered workspace binds are a loop.
    extraConfig = ''
      hl.on("hyprland.start", function()
        --TODO: pass cursor theme with global config
        hl.exec_cmd(${lua "gsettings set org.gnome.desktop.interface cursor-theme 'volantes_cursors'"})
        hl.exec_cmd(${lua "${startupScript}/bin/start"})
        hl.exec_cmd("telegram-desktop", { workspace = "9 silent" })
        hl.exec_cmd("blueman-applet")
      end)

      local mod = "SUPER"
      local terminal = ${lua terminal}
      local launcher = ${lua launcher.run}

      hl.bind(mod .. " + T", hl.dsp.exec_cmd(terminal))
      hl.bind(mod .. " + Return", hl.dsp.exec_cmd(terminal .. " -e tmux a"))
      hl.bind(mod .. " + R", hl.dsp.exec_cmd(launcher))
      hl.bind(mod .. " + G", hl.dsp.exec_cmd(launcher))
      hl.bind(mod .. " + B", hl.dsp.exec_cmd("firefox"))
      hl.bind(mod .. " + Q", hl.dsp.window.close())
      hl.bind(mod .. " + L", hl.dsp.exec_cmd("swaylock --grace 0 --fade-in 0"))
      hl.bind(mod .. " + SHIFT + F", hl.dsp.window.float({ action = "toggle" }))
      hl.bind(mod .. " + F", hl.dsp.window.fullscreen({ mode = "fullscreen" }))
      hl.bind(mod .. " + P", hl.dsp.layout("togglesplit"))
      hl.bind("ALT + Tab", hl.dsp.focus({ last = true }))
      hl.bind(mod .. " + Tab", function()
        hl.dispatch(hl.dsp.window.cycle_next())
        hl.dispatch(hl.dsp.window.alter_zorder({ mode = "top" }))
      end)

      hl.bind(mod .. " + mouse_down", hl.dsp.focus({ workspace = "e-1" }))
      hl.bind(mod .. " + mouse_up", hl.dsp.focus({ workspace = "e+1" }))
      hl.bind(mod .. " + SHIFT + left", hl.dsp.focus({ workspace = "e-1" }))
      hl.bind(mod .. " + SHIFT + right", hl.dsp.focus({ workspace = "e+1" }))
      hl.bind(mod .. " + SHIFT + X", hl.dsp.window.move({ monitor = "+1" }))
      hl.bind(mod .. " + X", hl.dsp.workspace.swap_monitors({ monitor1 = "current", monitor2 = "+1" }))

      hl.bind(mod .. " + left", hl.dsp.focus({ direction = "left" }))
      hl.bind(mod .. " + right", hl.dsp.focus({ direction = "right" }))
      hl.bind(mod .. " + up", hl.dsp.focus({ direction = "up" }))
      hl.bind(mod .. " + down", hl.dsp.focus({ direction = "down" }))

      for i = 1, 10 do
        local key = i % 10 -- workspace 10 is on key 0
        hl.bind(mod .. " + " .. key, hl.dsp.focus({ workspace = i }))
        hl.bind(mod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
      end

      hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+"))
      hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"))
      hl.bind(mod .. " + CTRL + K", hl.dsp.workspace.toggle_special("pass"))

      hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })
      hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
    '';
  };
}
