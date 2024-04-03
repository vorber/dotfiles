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
      {
        plugin = tmuxPlugins.continuum;
        extraConfig = ''
          set -g @continuum-restore 'on'
        '';
      }
      tmuxPlugins.tmux-fzf
      {
        plugin = inputs.tmux-sessionx.packages.${pkgs.system}.default;
        extraConfig = ''
          set -g @sessionx-zoxide-mode 'on'
          set -g @sessionx-bind 'o'
          set -g @sessionx-window-height '85%'
          set -g @sessionx-window-width '75%'
          set -g @sessionx-preview-location 'right'
          set -g @sessionx-preview-ratio '55%'
          set -g @sessionx-filter-current 'false'

          set -g @sessionx-bind-tree-mode 'alt-w'
          set -g @sessionx-bind-new-window 'alt-c'
          set -g @sessionx-bind-kill-session 'alt-x'
        '';
      }      
    ];
    extraConfig = ''
      set -g status-position top
      set -g @resurrect-strategy-nvim 'session'
    '';#TODO
    #TODO: misc shell scripts
  };
}
