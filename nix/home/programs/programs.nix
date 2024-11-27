{ config, pkgs, lib, ...}: 
{
  config = 
  {
    programs = {
      home-manager.enable = true;
      bat.enable = true;
      thefuck.enable = true;
      
      eza = {
        enable = true;
        extraOptions = [
          "--group-directories-first"
          "--header"
          "--git"
          "--icons"
          "--classify"
          "--time-style=long-iso"
          "--group"
          "--color-scale"
        ];
      };
      fzf = {
        enable = true;
        enableFishIntegration = true;

      };
      bash = {
        enable = true;
        profileExtra = builtins.readFile ../../../bash_profile;
        initExtra = builtins.readFile ../../../bashrc;
      };

      zoxide = {
        enable = true;
        enableFishIntegration = true;
      };

      starship = {
        enable = true;
        enableBashIntegration = true;
        enableZshIntegration = true;
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
      git-credential-oauth.enable = true;
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
          directory = /home/vorber/incoming/torrents/incomplete
          session = /home/vorber/incoming/.rtorrent
          port_range = 6900-6999
          encryption = allow_incoming,try_outgoing,enable_retry
          dht = on

          schedule2 = watch_start, 20, 10, "load.start=~/incoming/torrents/*.torrent, d.custom1.set=~/incoming/complete"

          # upon completion, move content to path specified above via custom1
          method.insert = d.data_path, simple, "if=(d.is_multi_file), (cat,(d.directory),/), (cat,(d.directory),/,(d.name))"
          method.insert = d.move_to_complete, simple, "d.directory.set=$argument.1=; execute=mkdir,-p,$argument.1=; execute=mv,-u,$argument.0=,$argument.1=; d.save_full_session="
          method.set_key = event.download.finished,move_complete,"d.move_to_complete=$d.data_path=,$d.custom1="
       '';        
      };
    };
  };
}
