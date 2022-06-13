{ pkgs, config, lib, ... }:
with lib;

let
  cfg = config.ggazzi.git;
in {
  options.ggazzi.git = {
    enable = mkOption {
      description = "Enable git";
      type = types.bool;
      default = false;
    };

    userName = mkOption {
      description = "Name for git";
      type = types.str;
      default = "Guilherme Grochau Azzi";
    };

    userEmail = mkOption {
      description = "Email for git";
      type = types.str;
      default = "gui.g.azzi@gmail.com";
    };

    gitg.enable = mkOption {
      description = "Enable gitg";
      type = types.bool;
      default = false;
    };
  };

  config = mkIf (cfg.enable) {
    programs.git = {
      enable = true;
      userName = cfg.userName;
      userEmail = cfg.userEmail;

      aliases = {
        co = "checkout";
        st = "status -s -- .";

        unstage = "reset HEAD";

        ls = "log --pretty=format:\"%C(yellow)%h%Cred%d\\ %Creset%s%Cblue\\ [%cn]\" --decorate";
        ll = "log --pretty=format:\"%C(yellow)%h%Cred%d\\ %Creset%s%Cblue\\ [%cn]\" --decorate --numstat";
        lg = "log --pretty=format:\"%C(yellow)%h%Cred%d\\ %Creset%s%Cblue\\ [%cn]\" --decorate --graph";
        linfo = "log -p --decorate";

        diff-tree = "git diff";
        dt = "git diff";
        diff-index = "git diff --cached";
        di = "git diff --cached";
      };

      delta.enable = true;

      extraConfig = {
        branch.autosetuprebase = "always";
        init.defaultBranch = "main";
      };
    };

    home.packages = if cfg.gitg.enable then [pkgs.gitg] else [];
  };
}
