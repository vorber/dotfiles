{ config, launcher, ... }:
let
  palette = config.colorScheme.palette;
  betterTransition = "all 0.3s cubic-bezier(.55,-0.68,.48,1.682)";
in
{
  programs.waybar = 
  {
    enable = true;

    settings = [{
      layer = "top";
      position = "top";

      modules-left = [
        "custom/start"
        "hyprland/workspaces"
        "hyprland/window"
        "hyprland/submap"
      ];
      modules-center = [
        "clock"
      ];
      modules-right = [
        "bluetooth"
        "pulseaudio" 
        "tray"
        "custom/exit"
      ];
#TODO: language
      "hyprland/workspaces" = {
      	format = "{icon}";#if bar-number == true then "{name}" else "{icon}";
      	format-icons = {
          #default = "";
          #active = "";
          #urgent = "";
          "1"= "";
          "2"= "";
          "3"= "";
          "4"= "󰲦";
          "5"= "󰲨";
          "6"= "󰲪";
          "7"= "󰲬";
          "8"= "󰲮";
          "9"= "";
          "10"= "";
          "urgent" = "󱨇";
          "default" = "";
          "empty" = "󱓼";
      	};
      	on-scroll-up = "hyprctl dispatch workspace r-1";
      	on-scroll-down = "hyprctl dispatch workspace r+1";
      };

      "clock" = {
        format = '' {:%H:%M}'';
      	tooltip = true;
        tooltip-format = "<big>{:%A, %d.%B %Y }</big><tt><small>{calendar}</small></tt>";
      };
      "hyprland/window" = {
      	max-length = 50;
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
        on-click = launcher.run;
      };
    }];
    style = ''
      * {
        font-size: 13px;
        font-family: JetBrainsMono Nerd Font, Font Awesome, sans-serif;
        font-weight: bold;
        min-height: 0;
      }
       
      window#waybar {
        background: rgba(26,27,38,0.4);
        border-bottom: 1px solid rgba(26,27,38,0.6);
        border-radius: 0px;
        color: #${palette.base0F};

        transition-property: background-color;
        transition-duration: .5s;
      }

      #workspaces {
        background: #${palette.base00};
        margin: 2px;
        padding: 0px 1px;
        border-radius:16px;
        border: 0px;
        font-style: normal;
        color: #${palette.base00};
      }
      #workspaces label {
        padding-right: 4px
      }
      #workspaces button {
        margin: 2px 2px;
        border-radius:16px;
        padding: 0px 1px;
        border: 0px;
        color: #${palette.base00};
        background: linear-gradient(45deg, #${palette.base0C}, #${palette.base0D}, #${palette.base0E});
        opacity: 0.5;
        transition: ${betterTransition};
      }

      #workspaces button.active {
        margin: 2px 2px;
        border-radius:16px;
        border: 0px;
        color: #${palette.base00};
        background: linear-gradient(45deg, #${palette.base0D}, #${palette.base0E});
        opacity: 1.0;
        min-width: 40px;
        transition: ${betterTransition};
      }

      #workspaces button:hover {
        border-radius:16px;
        color: #${palette.base00};
        background: linear-gradient(45deg, #${palette.base0D}, #${palette.base0E});
        opacity: 0.8;
        transition: ${betterTransition};
      }

      @keyframes gradient_horizontal {
        0% {
          background-position: 0% 50%;
        }
        50% {
          background-position: 100% 50%;
        }
        100% {
          background-position: 0% 50%;
        }
      }
      @keyframes swiping {
        0% {
          background-position: 0% 200%;
        }
        100% {
          background-position: 200% 200%;
        }
      }

      tooltip {
        background: #${palette.base00};
        border: 1px solid #${palette.base0E};
        border-radius: 16px;
      }
      tooltip label {
        color: #${palette.base07};
      }

      #window {
        color: #${palette.base05};
        background: #${palette.base00};
        border-radius: 30px 16px 30px 16px;
        margin: 2px;
        padding: 2px 20px;
      }

      #bluetooth {
        color: #${palette.base07};
        background: #${palette.base00};
        border-radius:16px 30px 16px 30px;
        margin: 2px;
        padding: 2px 20px;
      }
      #clock {
        color: #${palette.base0B};
        background: #${palette.base00};
        border-radius:16px 30px 16px 30px;
        margin: 2px;
        padding: 2px 20px;
      }

      #network {
        color: #${palette.base09};
        background: #${palette.base00};
        border-radius: 30px 16px 30px 16px;
        margin: 2px;
        padding: 2px 20px;
      }

      #custom-hyprbindings {
        color: #${palette.base0E};
        background: #${palette.base00};
        border-radius:16px 30px 16px 30px;
        margin: 2px;
        padding: 2px 20px;
      }

      #tray {
        color: #${palette.base05};
        background: #${palette.base00};
        border-radius:16px 30px 16px 30px;
        margin: 2px 0px 2px 2px;
        padding: 2px 20px;
      }

      #pulseaudio {
        color: #${palette.base0D};
        background: #${palette.base00};
        border-radius: 30px 16px 30px 16px;
        margin: 2px;
        padding: 2px 20px;
      }

      #custom-start {
        color: #${palette.base0D};
        background: #${palette.base00};
        border-radius: 0px 16px 30px 0px;
        margin: 2px 2px 2px 0px;
        padding: 2px 20px;
      }

      #custom-exit {
        color: #${palette.base0E};
        background: #${palette.base00};
        border-radius:16px 0px 0px 30px;
        margin: 2px 0px;
        padding: 2px 5px 2px 10px;
      }
    '';
  };
}
