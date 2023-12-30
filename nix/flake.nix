{
  description = "Home Manager configuration of vorber";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixgl = {
      url = "github:guibou/nixGL";
      #inputs.nixpkgs.follows = "nixpkgs";
    };    
  };

  outputs = { nixgl, nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";
      user = "vorber"; 
      
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        config.allowUnfreePredicate = (pkg: true);
        overlays = [ nixgl.overlay ];
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
      nixosConfigurations.${nixosFlake} = 
        let settings = {
          isNixOS = true;
          flakeName = "${nixosFlake}";
          games.enable = true;
        };
        in
          nixpkgs.lib.nixosSystem {
            inherit system;
            modules = [
              ./nixos/configuration.nix
                home-manager.nixosModules.home-manager {
                  home-manager.useUserPackages = true;
                  home-manager.users.${user}.imports = homeModules settings;
                }
            ];
          };
      generic = genericLinux.activationPackage;

      #homeConfigurations = (mkFlair "${user}-nixos" true) // (mkFlair "${user}-linux" false);
    };
}
