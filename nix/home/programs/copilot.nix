{ inputs, pkgs, ... }:
{
  home.packages = [
    inputs.github-copilot.packages.${pkgs.stdenv.hostPlatform.system}.github-copilot-desktop
  ];

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "x-scheme-handler/github-app" = [ "github-copilot-desktop.desktop" ];
      "x-scheme-handler/ghapp" = [ "github-copilot-desktop.desktop" ];
      "x-scheme-handler/gh" = [ "github-copilot-desktop.desktop" ];
    };
  };
}
