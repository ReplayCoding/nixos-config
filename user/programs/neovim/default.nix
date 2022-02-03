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
      (nvim-treesitter.withPlugins (plugins: pkgs.tree-sitter.allGrammars))
      gitsigns-nvim
      lualine-nvim
    ];
  };
  xdg.configFile."nvim/lua".source = ./lua;
}
