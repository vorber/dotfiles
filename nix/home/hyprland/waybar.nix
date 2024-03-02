{ config, pkgs, lib, inputs, ... }:
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

      modules-left = ["custom/start" "hyprland/window" "pulseaudio" "hyprland/submap"];
      modules-center = ["hyprland/workspaces" "clock"];
      modules-right = ["bluetooth" "custom/exit" "tray" ];
#TODO: language
      "hyprland/workspaces" = {
      	format = "{icon}";#if bar-number == true then "{name}" else "{icon}";
      	format-icons = {
          default = "";
          active = "";
          urgent = "";
            # "1": "󰲠",
            # "2": "󰲢",
            # "3": "󰲤",
            # "4": "󰲦",
            # "5": "󰲨",
            # "6": "󰲪",
            # "7": "󰲬",
            # "8": "󰲮",
            # "9": "󰲰",
            # "10": "󰿬",
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
        #on-click = "sleep 0.1 && wlogout";
        on-click = "pkill wofi || wofi-powermenu";
      };
      "custom/start" = {
        tooltip = false;
        format = " ";
        on-click = "pkill wofi || wofi -S drun";
      };
    }];
    style = ''
      * {
        font-size: 16px;
        font-family: JetBrainsMono Nerd Font, Font Awesome, sans-serif;
        font-weight: bold;
      }
       
      window#waybar {
        background-color: rgba(26,27,38,0);
        border-bottom: 1px solid rgba(26,27,38,0);
        border-radius: 0px;
        color: #${palette.base0F};

        transition-property: background-color;
        transition-duration: .5s;
      }

      #workspaces {
        background: #${palette.base00};
        margin: 5px;
        padding: 0px 1px;
        border-radius: 15px;
        border: 0px;
        font-style: normal;
        color: #${palette.base00};
      }

      #workspaces button {
        padding: 0px 5px;
        margin: 4px 3px;
        border-radius: 15px;
        border: 0px;
        color: #${palette.base00};
        background: linear-gradient(45deg, #${palette.base0C}, #${palette.base0D}, #${palette.base0E});
        opacity: 0.5;
        transition: ${betterTransition};
      }

      #workspaces button.active {
        padding: 0px 5px;
        margin: 4px 3px;
        border-radius: 15px;
        border: 0px;
        color: #${palette.base00};
        background: linear-gradient(45deg, #${palette.base0D}, #${palette.base0E});
        opacity: 1.0;
        min-width: 40px;
        transition: ${betterTransition};
      }

      #workspaces button:hover {
        border-radius: 15px;
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
        border-radius: 10px;
      }
      tooltip label {
        color: #${palette.base07};
      }

      #window {
        color: #${palette.base05};
        background: #${palette.base00};
        border-radius: 50px 15px 50px 15px;
        margin: 5px;
        padding: 2px 20px;
      }

      #clock {
        color: #${palette.base0B};
        background: #${palette.base00};
        border-radius: 15px 50px 15px 50px;
        margin: 5px;
        padding: 2px 20px;
      }

      #network {
        color: #${palette.base09};
        background: #${palette.base00};
        border-radius: 50px 15px 50px 15px;
        margin: 5px;
        padding: 2px 20px;
      }

      #custom-hyprbindings {
        color: #${palette.base0E};
        background: #${palette.base00};
        border-radius: 15px 50px 15px 50px;
        margin: 5px;
        padding: 2px 20px;
      }

      #tray {
        color: #${palette.base05};
        background: #${palette.base00};
        border-radius: 15px 0px 0px 50px;
        margin: 5px 0px 5px 5px;
        padding: 2px 20px;
      }

      #pulseaudio {
        color: #${palette.base0D};
        background: #${palette.base00};
        border-radius: 50px 15px 50px 15px;
        margin: 5px;
        padding: 2px 20px;
      }

      #custom-start {
        color: #${palette.base03};
        background: #${palette.base00};
        border-radius: 0px 15px 50px 0px;
        margin: 5px 5px 5px 0px;
        padding: 2px 20px;
      }

      #custom-exit {
        color: #${palette.base0E};
        background: #${palette.base00};
        border-radius: 15px 0px 0px 50px;
        margin: 5px 0px;
        padding: 2px 5px 2px 15px;
      }
    '';
  };
}
