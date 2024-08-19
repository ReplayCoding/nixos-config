{pkgs, ...}: {
  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      mkhl.direnv
      vscodevim.vim
      rust-lang.rust-analyzer
      vadimcn.vscode-lldb
      eamodio.gitlens
    ];

    userSettings = {
      "workbench.colorTheme" = "Visual Studio Light";
      "explorer.excludeGitIgnore" = true;
      "window.dialogStyle" = "custom";
      "window.titleBarStyle" = "custom";
      "terminal.integrated.sendKeybindingsToShell" = true;
    };
  };
  home.packages = with pkgs; [
    # LSP servers
    #python3Packages.python-lsp-server
    # rnix-lsp
    rust-analyzer
    clang-tools
    #gopls
    #zls
    #nodePackages.typescript-language-server
    #omnisharp-roslyn
    # jdt-language-server

    lldb
    gdb
  ];
}
