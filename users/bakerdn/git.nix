{...}: {
  programs.git = {
    enable = true;
    userName = "Daniel Baker";
    userEmail = "daniel.n.baker@gmail.com";
    extraConfig = {
      status = {
        short = "true";
        branch = "true";
      };
      init = {
        defaultBranch = "main";
      };
    };
  };
}
