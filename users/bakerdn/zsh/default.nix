{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableAutosuggestions = true;
    syntaxHighlighting.enable = true;
    defaultKeymap = "viins";
    localVariables = {
      PROMPT = "%B%F{green}%n@%m%k %B%F{blue}%1~ %# %b%f%k";
    };
    shellAliases = {
      lse = "ls -Fho";
      lsa = "lse -A";
    };
  };
}
