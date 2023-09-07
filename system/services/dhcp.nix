{ config, lib, ... }:
let
  cfg = config.jade.system.services.dhcp;
in
{
  # Disable extraneous DHCP options
  # TODO: consider whether this needs to be enabled on a home computer with a trusted router
  networking.dhcpcd.extraConfig = lib.mkIf (!cfg.trust) ''
    nohook resolv.conf
    nooption domain_name_servers, domain_name, domain_search, ntp_servers, host_name
  '';
}
