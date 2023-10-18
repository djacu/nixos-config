{...}: {
  programs.git = {
    enable = true;
    userName = "Daniel Baker";
    userEmail = "daniel.n.baker@gmail.com";
    extraConfig.core.editor = "vim";
    extraConfig.init.defaultBranch = "main";
  };
}
