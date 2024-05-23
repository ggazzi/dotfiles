{ pkgs, config, lib, ... }:

{
  config =
    let xdg = config.xdg;
    in {
      home.shellAliases.g = "git";

      programs.git = {
        enable = true;
        userName = "Guilherme Grochau Azzi";
        userEmail = "gazzi@babbel.com";

        lfs.enable = true;

        aliases = {
          st = "status -s -- .";
          a = "add";
          c = "commit";
          r = "restore";

          b = "branch";
          sw = "switch";

          unstage = "restore --staged";

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

      home.packages = with pkgs; [
        # Add custom git commands
        (pkgs.buildEnv {
          name = "custom-git-commands";
          paths = [ ./commands ];
        })

        lazygit
      ];
    };
}
