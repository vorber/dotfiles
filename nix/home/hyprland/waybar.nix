{ config, pkgs, lib, inputs, ... }:
{
  programs.waybar = 
  let 
    rofi-launcher = pkgs.writeShellScriptBin "rofi-launcher" ''
      if pgrep -x "rofi" > /dev/null; then
        # Rofi is running, kill it
        pkill -x rofi
        exit 0
      fi
      '';
  in
  {
    enable = true;

    settings = [{
      layer = "top";
      position = "top";

      modules-left = ["custom/start" "hyprland/workspaces"];
      modules-center = ["hyprland/window" "clock" "user"];
      modules-right = ["pulseaudio" "tray" "custom/exit"];
#TODO: language
      "hyprland/workspaces" = {
      	format = "{name}";#if bar-number == true then "{name}" else "{icon}";
      	format-icons = {
          default = " ";
          active = " ";
          urgent = " ";
      	};
      	on-scroll-up = "hyprctl dispatch workspace e+1";
      	on-scroll-down = "hyprctl dispatch workspace e-1";
      };

      "clock" = {
        format = ''{: %H:%M}'';
      	tooltip = true;
        tooltip-format = "<big>{:%A, %d.%B %Y }</big><tt><small>{calendar}</small></tt>";
      };
      "hyprland/window" = {
      	max-length = 25;
      	separate-outputs = false;
      };
      "tray" = {
        spacing = 12;
      };
      "pulseaudio" = {
        format = "{icon} {volume}% {format_source}";
        format-bluetooth = "{volume}% {icon} {format_source}";
        format-bluetooth-muted = " {icon} {format_source}";
        format-muted = " {format_source}";
        format-source = " {volume}%";
        format-source-muted = "";
        format-icons = {
          headphone = "";
          hands-free = "";
          headset = "";
          phone = "";
          portable = "";
          car = "";
          default = ["" "" ""];
        };
        on-click = "sleep 0.1 && pavucontrol";
      };
      
      "custom/exit" = {
        tooltip = false;
        format = "";
        on-click = "sleep 0.1 && wlogout";
      };
      "custom/start" = {
        tooltip = false;
        format = " ";
        # exec = "rofi -show drun";
        on-click = "sleep 0.1 && {$rofi-launcher}/bin/start";
      };
    }];
    style = ''
      * {
        font-size: 16px;
        font-family: JetBrainsMono Nerd Font, Font Awesome, sans-serif;
        font-weight: bold;
      }
       
      window#waybar {
        background-color: rgba(43, 48, 59, 0.5);
        border-bottom: 3px solid rgba(100, 114, 125, 0.5);
        color: #ffffff;
        transition-property: background-color;
        transition-duration: .5s;
      }

      window#waybar.hidden {
          opacity: 0.2;
      }

      button {
          /* Use box-shadow instead of border so the text isn't offset */
          box-shadow: inset 0 -3px transparent;
          /* Avoid rounded borders under each button name */
          border: none;
          border-radius: 0;
      }

      /* https://github.com/Alexays/Waybar/wiki/FAQ#the-workspace-buttons-have-a-strange-hover-effect */
      button:hover {
          background: inherit;
          box-shadow: inset 0 -3px #ffffff;
      }

#workspaces button {
          padding: 0 5px;
          background-color: transparent;
          color: #ffffff;
      }

#workspaces button:hover {
          background: rgba(0, 0, 0, 0.2);
      }

#workspaces button.focused {
          background-color: #64727D;
          box-shadow: inset 0 -3px #ffffff;
      }

#workspaces button.urgent {
          background-color: #eb4d4b;
      }

#mode {
          background-color: #64727D;
          box-shadow: inset 0 -3px #ffffff;
      }

#clock,
#battery,
#cpu,
#memory,
#disk,
#temperature,
#backlight,
#network,
#pulseaudio,
#wireplumber,
#custom-media,
#tray,
#mode,
#idle_inhibitor,
#scratchpad,
#mpd {
          padding: 0 10px;
          color: #ffffff;
      }

#window,
#workspaces {
          margin: 0 4px;
      }

      /* If workspaces is the leftmost module, omit left margin */
      .modules-left > widget:first-child > #workspaces {
          margin-left: 0;
      }

      /* If workspaces is the rightmost module, omit right margin */
      .modules-right > widget:last-child > #workspaces {
          margin-right: 0;
      }

#clock {
          background-color: #64727D;
      }

      @keyframes blink {
          to {
              background-color: #ffffff;
              color: #000000;
          }
      }

      label:focus {
          background-color: #000000;
      }

#cpu {
          background-color: #2ecc71;
          color: #000000;
      }

#memory {
          background-color: #9b59b6;
      }

#disk {
          background-color: #964B00;
      }

#backlight {
          background-color: #90b1b1;
      }

#network {
          background-color: #2980b9;
      }

#network.disconnected {
          background-color: #f53c3c;
      }

#pulseaudio {
          background-color: #f1c40f;
          color: #000000;
      }

#pulseaudio.muted {
          background-color: #90b1b1;
          color: #2a5c45;
      }

#wireplumber {
          background-color: #fff0f5;
          color: #000000;
      }

#wireplumber.muted {
          background-color: #f53c3c;
      }

#custom-media {
          background-color: #66cc99;
          color: #2a5c45;
          min-width: 100px;
      }

#custom-media.custom-spotify {
          background-color: #66cc99;
      }

#custom-media.custom-vlc {
          background-color: #ffa000;
      }

#temperature {
          background-color: #f0932b;
      }

#temperature.critical {
          background-color: #eb4d4b;
      }

#tray {
          background-color: #2980b9;
      }

#tray > .passive {
          -gtk-icon-effect: dim;
      }

#tray > .needs-attention {
          -gtk-icon-effect: highlight;
          background-color: #eb4d4b;
      }

#idle_inhibitor {
          background-color: #2d3436;
      }

#idle_inhibitor.activated {
          background-color: #ecf0f1;
          color: #2d3436;
      }

#mpd {
          background-color: #66cc99;
          color: #2a5c45;
      }

#mpd.disconnected {
          background-color: #f53c3c;
      }

#mpd.stopped {
          background-color: #90b1b1;
      }

#mpd.paused {
          background-color: #51a37a;
      }

#language {
          background: #00b093;
          color: #740864;
          padding: 0 5px;
          margin: 0 5px;
          min-width: 16px;
      }

#keyboard-state {
          background: #97e1ad;
          color: #000000;
          padding: 0 0px;
          margin: 0 5px;
          min-width: 16px;
      }

#keyboard-state > label {
          padding: 0 5px;
      }

#keyboard-state > label.locked {
          background: rgba(0, 0, 0, 0.2);
      }

#scratchpad {
          background: rgba(0, 0, 0, 0.2);
      }

#scratchpad.empty {
        background-color: transparent;
      }

#privacy {
          padding: 0;
      }

#privacy-item {
          padding: 0 5px;
          color: white;
      }

#privacy-item.screenshare {
          background-color: #cf5700;
      }

#privacy-item.audio-in {
          background-color: #1ca000;
      }

#privacy-item.audio-out {
          background-color: #0069d4;
      }
    '';
  };
}
