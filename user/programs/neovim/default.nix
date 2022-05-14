{pkgs, ...}: {
  home.sessionVariables = rec {
    EDITOR = "nvim";
    VISUAL = EDITOR;
  };

  programs.neovim = {
    enable = true;
    extraConfig = "lua require('init')";
    extraPackages = with pkgs; [
      pyright
    ];
    plugins = with pkgs.vimPlugins; [
      (nvim-treesitter.withPlugins (plugins: pkgs.tree-sitter-optimised-grammars))
      nvim-lspconfig
      lightspeed-nvim
      gitsigns-nvim
      lualine-nvim
      comment-nvim
      catppuccin-nvim
    ];
  };
  xdg.configFile."nvim/lua".source = pkgs.callPackage ./fnl {};
}
