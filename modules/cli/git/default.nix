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
          # commit.template = "${config.xdg.configHome}/git/commit-template.txt";

          "includeIf \"gitdir:${config.ggazzi.dev.workspace}/babbel/\"".path = "${xdg.configHome}/git/babbel-config.inc";
          "includeIf \"gitdir:${config.ggazzi.dev.workspace}/babbel-didactics/\"".path = "${xdg.configHome}/git/babbel-config.inc";
          "includeIf \"gitdir:${config.ggazzi.dev.workspace}/lessonnine/\"".path = "${xdg.configHome}/git/babbel-config.inc";
        };

        ignores = [
          ".DS_Store"
          "*.code-workspace"
          ".vscode/*"
        ];
      };

      xdg.configFile = {
        "git/babbel-config.inc".source = ./babbel-config.inc;
        "git/commit-template.txt".source = ./commit-template.txt;
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
