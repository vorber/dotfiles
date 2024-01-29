{pkgs, config, lib, ... }:
{
  config = {
    programs.fish = {
      enable = true;
      shellAbbrs = {
        g = "git";
        v = "nvim";
        vim = "nvim";
        hm = "home-manager";

        hms="home-manager switch --flake ~/dotfiles/nix#${config.flakeName}";
        hmp="home-manager packages";
        hmu="nix flake update ~/dotfiles/nix/home && hms";
        hmf="home-manager --flake ~/dotfiles/nix#${config.flakeName}";
        nrs="sudo nixos-rebuild switch --flake ~/dotfiles/nix#${config.flakeName}";
        nru="sudo nixos-rebuild switch --flake ~/dotfiles/nix#${config.flakeName}";

      };
      plugins = [
        {
          name = "z";
          src = pkgs.fetchFromGitHub {
            owner = "jethrokuan";
            repo = "z";
            rev = "85f863f20f24faf675827fb00f3a4e15c7838d76";
            sha256 = lib.fakeSha256;
          };
        }
      ];
      
    };
  };
}
