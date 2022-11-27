{ pkgs, config, lib, ... }:
with lib;

let cfg = config.ggazzi.graphical.gnome;
in {

  options.ggazzi.graphical.gnome = {
    enable = mkOption {
      description = "Enable a GNOME-based graphical environment";
      type = types.bool;
      default = false;
    };
  };

  config = mkIf (config.ggazzi.graphical.enable && cfg.enable) {
    services.xserver.desktopManager.gnome.enable = true;

    # Set some default MIME associations
    xdg.mime = {
      enable = true;
      addedAssociations = {
        "application/pdf" = "org.gnome.Evince.desktop";

        "application/x-yaml" = "org.gnome.TextEditor.desktop";
        "text/plain" = "org.gnome.TextEditor.desktop";
      };
      defaultApplications = {
        "application/pdf" = "org.gnome.Evince.desktop";
        "inode/directory" = "org.gnome.Nautilus.desktop";
      };
    };

  };

}
