{ pkgs, lib, ... }:
{
  programs.zsh = {
    initContent = lib.mkOrder 1000 ''
      bindkey "^R" history-incremental-search-backward
    '';

    shellAliases = {
      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";

      "l" = "ls -CFh";
      "la" = "ls -CFAh";
      "ll" = "ls -CFAlh";
    }
    // (if pkgs.stdenv.isDarwin then { "ls" = "ls -G"; } else { });
  };
}
