{
  enable = true;
  enableAutosuggestions = true;
  enableCompletion = true;
  enableSyntaxHighlighting = true;
  autocd = true;
  defaultKeymap = "emacs";
  dotDir = ".config/zsh";
  history.ignorePatterns = [ "ls" "clear" "celar" /* common typo */ ]; # I have a bad habit of spamming these commands
}
