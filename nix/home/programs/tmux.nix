{ pkgs, inputs, config, ... }:
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
      tmuxPlugins.catppuccin#TODO: sync with global theme
      tmuxPlugins.continuum
      tmuxPlugins.tmux-fzf
      {
        plugin = inputs.tmux-sessionx.packages.${pkgs.system}.default;
        extraConfig = ''
            set -g @sessionx-zoxide-mode 'on'
            set -g @sessionx-bind 'l'
            set -g @sessionx-window-height '85%'
            set -g @sessionx-window-width '75%'
            set -g @sessionx-preview-location 'right'
            set -g @sessionx-preview-ratio '55%'
            set -g @sessionx-filter-current 'false'

            set -g @sessionx-bind-tree-mode 'ctrl-w'
            set -g @sessionx-bind-new-window 'ctrl-c'
            set -g @sessionx-bind-kill-session 'ctrl-d'
        '';
      }      
    ];
    extraConfig = ''
      set -g status-position top
    '';#TODO
    #TODO: misc shell scripts
  };
}
