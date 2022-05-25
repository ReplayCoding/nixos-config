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
      rnix-lsp
      rust-analyzer
    ];
    plugins = with pkgs.vimPlugins; [
      (nvim-treesitter.withPlugins (plugins: pkgs.tree-sitter-optimised-grammars))
      nvim-lspconfig
      lightspeed-nvim
      gitsigns-nvim
      lualine-nvim
      comment-nvim
      tokyonight-nvim
      telescope-nvim
      nvim-cmp
      cmp-nvim-lsp
      cmp_luasnip
      lspkind-nvim
      nvim-ts-rainbow
      fidget-nvim
      luasnip
    ];
  };
  xdg.configFile."nvim/lua".source = pkgs.callPackage ./fnl {};
}
