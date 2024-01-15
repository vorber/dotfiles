{ config, pkgs, lib, ...}: 
{
  config = 
  {
    programs = {
      home-manager.enable = true;
      bat.enable = true;
      thefuck.enable = true;
      
      bash = {
        enable = true;
        profileExtra = builtins.readFile ../../../bash_profile;
        initExtra = builtins.readFile ../../../bashrc;
      };

      zsh = {
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

      starship = {
        enable = true;
        settings = pkgs.lib.importTOML ../../../starship.toml;
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

      rtorrent = {
        enable = true;
        #TODO: don't hardcode home path
        extraConfig = ''
          upload_rate = 1000
          directory = /home/vorber/incoming
          session = /home/vorber/incoming/.rtorrent
          port_range = 6900-6999
          encryption = allow_incoming,try_outgoing,enable_retry
          dht = on
          schedule2 = watch_start, 20, 10, "load.start=~/incoming/torrents/*.torrent"
       '';        
      };
    };
  };
}
