{ pkgs, config, lib, ... }:
with builtins;

{
  config = {
    programs.bash = {
      enable = true;
      enableVteIntegration = true;
      shellOptions = [ "globstar" ];
      historyIgnore = [ "ls" "cd" "exit" ];

      bashrcExtra = ''
        ${readFile ./cuteprompt.sh}
        ${readFile ./python-argcomplete.sh}
      '';
    };

    home.packages = with pkgs; [ bash-completion ];
  };
}
