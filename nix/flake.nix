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
      home = flakeName: isNixOS: import ./home/get.nix { inherit pkgs isNixOS flakeName; };
      genericLinux = home-manager.lib.homeManagerConfiguration {
        inherit system;
      	configuration = { imports = (home "generic" false).modules; };
        homeDirectory = "/home/${user}";
        username = user;
        stateVersion = "23.11";
      };
    in {

      nixosConfigurations.${user} = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./nixos/configuration.nix
          home-manager.nixosModules.home-manager {
            home-manager.useUserPackages = true;
            home-manager.users.${user} = { imports = (home "${user}" true).modules; };
          }
        ];
      };
      generic = genericLinux.activationPackage;

      #homeConfigurations = (mkFlair "${user}-nixos" true) // (mkFlair "${user}-linux" false);
    };
}
