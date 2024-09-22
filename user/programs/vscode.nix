{pkgs, ...}: {
  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      mkhl.direnv
      vscodevim.vim
      rust-lang.rust-analyzer
      vadimcn.vscode-lldb
      llvm-vs-code-extensions.vscode-clangd
      eamodio.gitlens
      vscjava.vscode-gradle
      redhat.java
      vscjava.vscode-java-debug
      vscjava.vscode-maven
      vscjava.vscode-java-test
      vscjava.vscode-java-dependency
    ];

    userSettings = {
      "workbench.colorTheme" = "Visual Studio Light";
      "explorer.excludeGitIgnore" = true;
      "window.dialogStyle" = "custom";
      "window.titleBarStyle" = "custom";
      "window.autoDetectColorScheme" = true;
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
    jdt-language-server

    lldb
    gdb
  ];
}
