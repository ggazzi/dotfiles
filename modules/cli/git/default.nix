{ pkgs, config, lib, ... }:

{
  config = {
    home.shellAliases.g = "git";

    programs.git = {
      enable = true;
      userName = "Guilherme Grochau Azzi";
      userEmail = "gazzi@babbel.com";

      lfs.enable = true;

      aliases = {
        a = "add";
        b = "branch";

        cm = "commit";
        co = "checkout";
        st = "status -s -- .";

        unstage = "reset HEAD";

        l = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%ad) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative";
        ls = "log --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%ad) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative";
        ll = "log --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%ad) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative --numstat";
        lg = "log --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%ad) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative --graph";
        la = "log --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%ad) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative --graph --all";

        diff-tree = "diff";
        dt = "diff";
        diff-index = "diff --cached";
        di = "diff --cached";
      };

      delta.enable = true;

      extraConfig = {
        branch.autosetuprebase = "always";
        init.defaultBranch = "main";
      };

      ignores = [
        ".DS_Store"
        "*.code-workspace"
        ".vscode/*"
      ];
    };

    # Add custom git commands
    home.packages = [
      (pkgs.buildEnv {
        name = "custom-git-commands";
        paths = [ ./commands ];
      })
    ];
  };
}
