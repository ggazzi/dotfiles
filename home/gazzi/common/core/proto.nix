{ pkgs, lib, ... }:

{
  home.packages = with pkgs; [ proto ];

  # I use the shell activation workflow.
  # Hopefully, this will play nicely with asdf and nix
  # (assuming each project uses only one of these tools)
  programs.zsh.initContent = lib.mkOrder 1000 ''
    PATH="$HOME/.proto/bin:$PATH"
    eval "$(proto activate zsh)"
  '';
}
