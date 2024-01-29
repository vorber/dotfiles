{pkgs, config, ... }:
{
  config = {
    programs.zsh = {
      enable = true;
      shellAliases = {
        hm="home-manager";
        hmd="cd ~/dotfiles/nix/home/";
        hms="home-manager switch --flake ~/dotfiles/nix#${config.flakeName}";
        hmp="home-manager packages";
        hmu="nix flake update ~/dotfiles/nix/home && hms";
        hmf="home-manager --flake ~/dotfiles/nix#${config.flakeName}";
        nrs="sudo nixos-rebuild switch --flake ~/dotfiles/nix#${config.flakeName}";
        nru="sudo nixos-rebuild switch --flake ~/dotfiles/nix#${config.flakeName}";
        vim="nvim";
        ".."="cd ..";
      };
      history.size = 10000;
      history.path = "${config.xdg.dataHome}/zsh/history";
      initExtra = ''
        if [ -f "/home/vorber/.nix-profile/etc/profile.d/nix.sh" ]; then
          source /home/vorber/.nix-profile/etc/profile.d/nix.sh 
        fi
        
        export DOTNET_ROOT=$HOME/.dotnet
        export PATH=$PATH:$HOME/.dotnet/tools
        export PATH=$PATH:$HOME/.dotnet
      '';
      oh-my-zsh = {
        enable = true;
        plugins = [ "command-not-found" "common-aliases" "dotnet" "extract" "fancy-ctrl-z" "starship" "themes" "vim-interaction" ];
        theme = "af-magic";
      };
    };
    home.packages = with pkgs; [ zsh ];
  };
}
