{ config, lib, pkgs, options, osConfig, ... }:
with lib;
let
  cfg = config.jade.home.development;
in
{
  config = mkIf cfg.enable {
    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;
      # Control sockets
      #controlMaster = "auto";
      #controlPath = "${ssh}/control/master-%r@%n:%p";
      #controlPersist = "5m";
      matchBlocks."*" = {
        # Best practices security settings
        hashKnownHosts = true;
        extraOptions = {
          IdentitiesOnly = "yes";
          ForwardAgent = "no";
        };
      };
    };
  };
}
