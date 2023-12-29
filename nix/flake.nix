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
      pkgs = import nixpkgs {
        inherit system;
        pkgs.overlays = [ nixgl.overlay ];
      };
      user = "vorber"; 
      home = flakeName: isNixOS: import ./home/get.nix { inherit pkgs isNixOS flakeName; };
      mkFlair = name: isNixOS: {
        "${name}" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          inherit (home name isNixOS) modules;
          # Optionally use extraSpecialArgs
          # to pass through arguments to home.nix
        };
      };
    in {
      homeConfigurations = (mkFlair "${user}-nixos" true) // (mkFlair "${user}-linux" false);
    };
}
