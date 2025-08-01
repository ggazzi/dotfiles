{ pkgs, lib, ... }:

{
  home.packages = with pkgs; [ asdf-vm ];

  programs.zsh.initContent = lib.mkOrder 1000 ''
    source "$HOME/.nix-profile/share/asdf-vm/asdf.sh"
  '';
}
