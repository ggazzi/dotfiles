{ pkgs, config, lib, ... }:
with lib; let
  cfg = config.ggazzi.applications;
  systemCfg = config.machineData.systemConfig;
in {

  imports = [
    ./vscode
    ./vivaldi.nix
  ];

  config = mkIf (cfg.enable && systemCfg.graphical.enable) {
    home.packages = with pkgs; [
      # Password manager
      keepassxc

      # Cloud Storage
      seafile-client

      # Office tools
      onlyoffice-bin

      # Communication tools
      tdesktop discord

      # Fonts
      fira fira-mono fira-code fira-code-symbols

      # Text tools
      meld
    ];

    # Visual Studio Code as a text editor
    programs.vscode.enable = true;

    # Make discord work even when the latest version isn't available on nix
    xdg.configFile."discord/settings.json".text = ''
      { "SKIP_HOST_UPDATE": true }
    '';

    fonts.fontconfig.enable = true;
  };

}
