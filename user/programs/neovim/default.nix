{
  flib,
  pkgs,
  ...
}: {
  home.sessionVariables = rec {
    EDITOR = "nvim";
    VISUAL = EDITOR;
  };

  programs.neovim = {
    enable = true;
    extraConfig = "lua require('init')";
    extraPackages = let
      clangd = pkgs.clang-tools.override {llvmPackages = pkgs.llvmPackages_14;};
    in
      with pkgs; [
        pyright
        rnix-lsp
        rust-analyzer
        clangd
        nodePackages.typescript-language-server
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
      project-nvim
    ];
  };
  xdg.configFile."nvim/lua".source = pkgs.callPackage ./fnl {};
}
