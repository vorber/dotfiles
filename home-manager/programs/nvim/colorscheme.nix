{ pkgs, ...}:
{
  programs.neovim = {
    plugins = with pkgs.vimPlugins; [
  {
      plugin = rose-pine;
      type = "lua";
      config = /* lua */''
        require("rose-pine").setup({
            variant = 'auto',
            })
      '';
  }
    ];
    extraLuaConfig = /* lua */ ''
        vim.cmd('colorscheme rose-pine')
    '';
  };
}
