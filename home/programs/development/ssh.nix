{ config, lib, pkgs, options, osConfig, ... }:
with lib;
let
  cfg = config.jade.home.development;
in
{
  config = mkIf cfg.enable {
    programs.ssh = {
      enable = true;
      # Best practices security settings
      hashKnownHosts = true;
      extraOptionOverrides = {
        IdentitiesOnly = "yes";
        ForwardAgent = "no";
      };
      # Control sockets
      #controlMaster = "auto";
      #controlPath = "${ssh}/control/master-%r@%n:%p";
      #controlPersist = "5m";
    };
  };
}
