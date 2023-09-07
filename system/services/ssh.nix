{ config, lib, ... }:
let
  cfg = cfg.jade.system.services.ssh;
in
{
  # Turns on openssh
  services.openssh = {
    # Always enable (so agenix has a key to use)
    enable = true;
    # Never allow password auth
    passwordAuthentication = false;
    # Never allow root auth
    permitRootLogin = "no";
    # Set up ssh to listen only on localhost if not enabled
    listenAddresses = lib.optionals (!cfg.enabled) [
      {
        addr = "127.0.0.1";
        port = 22;
      }
    ];
    # Don't open firewall if not enabled
    openFirewall = !cfg.enabled;
    # TODO: put cipher options here
  };
}
