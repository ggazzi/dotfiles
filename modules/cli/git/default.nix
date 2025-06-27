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
          bd = "describe-branch";
          bda = "describe-branches";
          bdw = "branch --edit-description";
          db = "bd";
          dba = "bda";
          dbw = "bdw";
          sw = "switch";

          describe-branch = "!git config --get branch.$(git branch --show-current).description";
          describe-branches = ''!git config --get-regexp branch.*.description | sed "s_branch\\.\\(.*\\)\\.description \\(.*\\)_\x1b[1;3;34m\\1\\x1b[0m\n\\2_g"'';

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
