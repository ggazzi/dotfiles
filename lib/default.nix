{ pkgsBySystem, home-manager, lib, ... }:
rec {
  user = import ./user.nix { inherit pkgsBySystem home-manager lib; };
  host = import ./host.nix { inherit pkgsBySystem home-manager lib user; };
}
