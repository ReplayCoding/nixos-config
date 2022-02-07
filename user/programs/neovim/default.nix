{ pkgs, ... }:

{
  home.sessionVariables = rec {
    EDITOR = "nvim";
    VISUAL = EDITOR;
  };

  programs.neovim = {
    enable = true;
    extraConfig = "lua require('init')";
    plugins = with pkgs.vimPlugins; [
      (nvim-treesitter.withPlugins (plugins: pkgs.tree-sitter-optimised-grammars))
      lightspeed-nvim
      gitsigns-nvim
      lualine-nvim
      comment-nvim
    ];
  };
  xdg.configFile."nvim/lua".source = pkgs.callPackage ./fnl { };
}
