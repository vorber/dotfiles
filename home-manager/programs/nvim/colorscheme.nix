{ pkgs, ...}:
{
  programs.neovim = {
    plugins = with pkgs.vimPlugins; [
      rose-pine
    ];
#    extraLuaConfig = /* lua */ ''
#    '';
  };
}
