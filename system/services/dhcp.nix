{ config, lib, ... }:
with lib;
let
  cfg = config.jade.system.services.dhcp;
in
{
  options = {
    jade.system.services.dhcp = {
      trust = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to trust the system's dhcp";
      };
    };
  };
  config = {
    # Disable extraneous DHCP options
    # TODO: consider whether this needs to be enabled on a home computer with a trusted router
    networking.dhcpcd.extraConfig = lib.mkIf (!cfg.trust) ''
      nohook resolv.conf
      nooption domain_name_servers, domain_name, domain_search, ntp_servers, host_name
    '';
  };
}
