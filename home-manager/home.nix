{ config, pkgs, lib, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "vorber";
  home.homeDirectory = "/home/vorber";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    git
    bat
    zsh
    starship
    thefuck
    foot
    bashInteractive
# # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
     # ".config/bash/.bashrc" = ../bashrc;
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. If you don't want to manage your shell through Home
  # Manager then you have to manually source 'hm-session-vars.sh' located at
  # either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/vorber/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    TERMINAL = "foot";
    EDITOR = "nvim";
    SHELL = "zsh";   
  };

  targets.genericLinux.enable = true;
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  programs.bat.enable = true;
  programs.thefuck.enable = true;
  programs.foot.enable = true;
  programs.bash = {
    enable = true;
    profileExtra = builtins.readFile ../bash_profile;
    initExtra = builtins.readFile ../bashrc;
  };

  programs.zsh = {
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

  programs.starship = {
    enable = true;
    settings = pkgs.lib.importTOML ../starship.toml;
  };

  programs.git = {
    enable = true;
    userName = "vorber";
    userEmail = "vorber@gmail.com";
    delta.enable = true;
    includes = [
      { path = "~/.gitlocalconfig"; }
    ];
  };
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
  };

}
