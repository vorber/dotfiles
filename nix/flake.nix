{
  description = "Home Manager configuration of vorber";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    systems.url = "github:nix-systems/default";
    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.systems.follows = "systems";
    };
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
    tmux-sessionx.url = "github:omerxx/tmux-sessionx";
  };

  outputs = inputs@{ nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";
      user = "vorber"; 
      
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        config.allowUnfreePredicate = (pkg: true);
      };
      homeModules = settings: (import ./home/get.nix { inherit pkgs settings; }).modules;
      genericLinux = 
        let settings = {
          isNixOS = false;
          flakeName = "generic";
          games.enable = false;
          };
        in 
          home-manager.lib.homeManagerConfiguration {
            inherit system;
            configuration.imports = homeModules settings;
            homeDirectory = "/home/${user}";
            username = user;
            stateVersion = "23.11";
          };
      nixosFlake = "${user}-nixos";
    in {
      nixosConfigurations = {
        ${nixosFlake} = 
          let settings = {#TODO: move these to use specialArgs/extraSpecialArgs
            isNixOS = true;
            flakeName = "${nixosFlake}";
            games.enable = true;
          };
          in
            nixpkgs.lib.nixosSystem {
              inherit system pkgs;
              specialArgs = {
                inherit system inputs user;
                isContainer = false;
              };
              modules = [
                ./nixos/common.nix
                ./nixos/nixos.nix
                home-manager.nixosModules.home-manager 
                {
                  home-manager = {
                    useUserPackages = true;
                    users.${user}.imports = homeModules settings;
                    extraSpecialArgs = { inherit inputs; };
                  };
                }
              ];
            };
        wsl = 
          let settings = {
            isNixOS = true;
            flakeName = "wsl";
            games.enable = false;
          };
          in
            nixpkgs.lib.nixosSystem {
              inherit system pkgs;
              specialArgs = {
                inherit system inputs user;
                isContainer = false;
              };
              modules = [
                ./nixos/common.nix
                ./nixos/wsl.nix
                  home-manager.nixosModules.home-manager {
                    home-manager.useUserPackages = true;
                    home-manager.users.${user}.imports = homeModules settings;
                  }
              ];
            };

            
      };
      generic = genericLinux.activationPackage;

      #homeConfigurations = (mkFlair "${user}-nixos" true) // (mkFlair "${user}-linux" false);
    };
}
