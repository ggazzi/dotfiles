{
  config,
  ...
}:
let
  sshPort = config.hostSpec.networking.ports.tcp.ssh;
in

{
  services.openssh = {
    enable = true;
    ports = [ sshPort ];

    settings = {
      # Harden
      PermitRootLogin = "no";
      # Authomatically remove stale sockets
      StreamLocalBindUnlink = true;
    };
  };

  networking.firewall.allowedTCPPorts = [ sshPort ];
}
