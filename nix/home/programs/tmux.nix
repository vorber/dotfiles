{ pkgs, config }:
{
  programs.tmux = {
    enable = true;
    escapeTime = 0;
    baseIndex = 1;
    secureSocket = false;
    #TODO: take shell from config
    shell = "${pkgs.fish}/bin/fish";
    terminal = "screen-256color";
    #keyMode = "vi";
    historyLimit = 100000;
    mouse = true;
    plugins = with pkgs; [
      {
        plugin = tmuxPlugins.resurrect;
        extraConfig = "";#TODO
      }
    ];
    extraConfig = "";#TODO
    #TODO: misc shell scripts
  };
}
