{user, repo, ref ? "HEAD", buildScript ? ":"}:

let
  pkgs = import <nixpkgs> {};
in

pkgs.vimUtils.buildVimPluginFrom2Nix {
  pname = "${pkgs.lib.strings.sanitizeDerivationName repo}";
  version = ref;
  src = builtins.fetchGit {
    url = "https://github.com/${user}/${repo}.git";
    inherit ref;
  };
  inherit buildScript;
}
