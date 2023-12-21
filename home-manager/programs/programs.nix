{ config, pkgs, lib, ...}:
{
  programs = {
    home-manager.enable = true;
    bat.enable = true;
    thefuck.enable = true;
    
    bash = {
      enable = true;
      profileExtra = builtins.readFile ../../bash_profile;
      initExtra = builtins.readFile ../../bashrc;
    };

    zsh = {
      enable = true;
      shellAliases = {
        hm="home-manager";
        hmd="cd ~/dotfiles/home-manager/";
        hms="home-manager switch --flake ~/dotfiles/home-manager#vorber";
        hmp="home-manager packages";
        hmu="nix flake update ~/dotfiles/nix/home-manager && hms";
        hmf="home-manager --flake ~/dotfiles/home-manager#vorber";
        vim="nvim";
        ".."="cd ..";
      };
      history.size = 10000;
      history.path = "${config.xdg.dataHome}/zsh/history";
      initExtra = ''
        source /home/vorber/.nix-profile/etc/profile.d/nix.sh
        
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

    starship = {
      enable = true;
      settings = pkgs.lib.importTOML ../../starship.toml;
    };

    
    git = {
      enable = true;
      userName = "vorber";
      userEmail = "vorber@gmail.com";
      delta.enable = true;
      includes = [
        { path = "~/.gitlocalconfig"; }
      ];
    };
    direnv = {
      enable = true;
      nix-direnv.enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
    };
  };
}
