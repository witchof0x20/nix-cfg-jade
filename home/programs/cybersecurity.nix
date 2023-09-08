{ config, lib, pkgs, options, osConfig, ... }:
with lib;
let
  cfg = config.jade.home.programs.cybersecurity;
in
{
  options = {
    jade.home.programs.cybersecurity = {
      enable = mkEnableOption "tools for cybersecurity stuff";
    };
  };
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      nmap
    ];
  };
}
