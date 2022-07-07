{ pkgs, config, lib, ... }:
with lib;

let
  cfg = config.ggazzi.sshd;
in {
  options.ggazzi.sshd = {
    enable = mkOption {
      description = "Enable the openssh server daemon";
      type = types.bool;
      default = false;
    };
  };

  config = mkIf (cfg.enable) {
    services.openssh.enable = cfg.enable;

    # I want to have tmux whenever I connect to a machine via ssh
    environment.systemPackages = with pkgs; [ tmux ];
  };
}
