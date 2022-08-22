{ pkgs, config, lib, ... }:
with lib; let
  # cfg = config.ggazzi.desktop.gnome;
  systemCfg = config.machineData.systemConfig.graphical;
in {
  config = mkIf (systemCfg.enable && systemCfg.gnome.enable) {

    home.packages = with pkgs; [
      gnome.gnome-tweaks
    ];

    gtk = {
      enable = true;
      theme = {
        package = pkgs.orchis-theme;
        name = "Orchis";
      };
      iconTheme = {
        package = pkgs.arc-icon-theme;
        name = "Arc";
      };
      gtk3.extraConfig = {
        gtk-application-prefer-dark-theme = true;
      };
    };

    xdg.mimeApps = {
      defaultApplications = {
        "application/pdf" = "evince.desktop";
        "inode/directory" = "org.gnome.Nautilus.desktop";
      };
    };

    services = {
      gnome-keyring.enable = true;
    };

  };
}
