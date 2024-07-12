{pkgs, ...}: {
  home.packages = with pkgs; [
    kate

    universal-ctags

    # LSP servers
    python3Packages.python-lsp-server
    # rnix-lsp
    rust-analyzer
    clang-tools
    gopls
    zls
    nodePackages.typescript-language-server
    omnisharp-roslyn
    # jdt-language-server

    # Debugging integration
    gdb
  ];
}
