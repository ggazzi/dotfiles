{ pkgs, config, lib, ... }:
with lib;

# Configuration for laptops with NVidia Optimus technology

let   
  cfg = config.ggazzi.desktop.nvidia-optimus;

  nvidia-offload = pkgs.writeShellScriptBin "nvidia-offload" ''
    export __NV_PRIME_RENDER_OFFLOAD=1
    export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    export __VK_LAYER_NV_optimus=NVIDIA_only
    exec -a "$0" "$@"
  '';
in {
  options.ggazzi.desktop.nvidia-optimus = {
    enable = mkOption {
      description = "Configure the system to use NVidia Optimus graphic cards";
      type = types.bool;
      default = false;
    };

    intelBusId = mkOption {
      description = ''
        Bus ID for the Intel graphics card.
        Can be obtained from lspci (see [https://nixos.wiki/wiki/Nvidia#lspci]).
      '';
      type = types.str;
    };

    nvidiaBusId = mkOption {
      description = ''
        Bus ID for the NVidia graphics card.
        Can be obtained from lspci (see [https://nixos.wiki/wiki/Nvidia#lspci]).
      '';
      type = types.str;
    };
  };

  config = mkIf (cfg.enable) {
    environment.systemPackages = [ nvidia-offload ];

    services.xserver.videoDrivers = [ "nvidia" ];

    hardware.nvidia.prime = {
      offload.enable = true;
      intelBusId = cfg.intelBusId;
      nvidiaBusId = cfg.nvidiaBusId;
    };

    # TODO: should I have an option to set `hardware.nvidia.nvidiaPersistenced`?
    # hardware.nvidia.nvidiaPersistenced = true; # default is false
  };
}