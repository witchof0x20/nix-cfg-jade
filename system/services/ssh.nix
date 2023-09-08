{ config, lib, options, ... }:
with lib;
let
  cfg_top = config.jade.system;
  cfg = cfg_top.services.ssh;
in
{
  options = {
    # Whether to enable ssh
    jade.system.services.ssh = mkOption {
      description = "Custom SSH settings";
      type = types.submodule {
        options = {
          enable = mkEnableOption "logging in via SSH";
        };
      };
    };
  };
  config = mkIf cfg_top.enable {
    # Turns on openssh
    services.openssh = {
      # Always enable (so agenix has a key to use)
      enable = true;
      # Never allow password auth
      passwordAuthentication = false;
      # Never allow root auth
      permitRootLogin = "no";
      # Set up ssh to listen only on localhost if not enabled
      listenAddresses = lib.optionals (!cfg.enable) [
        {
          addr = "127.0.0.1";
          port = 22;
        }
      ];
      # Don't open firewall if not enabled
      openFirewall = !cfg.enable;
      # TODO: put cipher options here
    };
  };
}
