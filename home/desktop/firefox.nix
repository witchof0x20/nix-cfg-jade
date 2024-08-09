{ config, lib, pkgs, options, osConfig, ... }:
with lib;
let
  cfg = config.jade.home.programs.firefox;
in
{
  imports = [ ];
  options = {
    jade.home.programs.firefox = {
      enable = mkOption {
        type = types.bool;
        default = osConfig.jade.system.graphical.enable;
        description = "Whether to enable Firefox";
      };
    };
  };
  config = mkIf cfg.enable {
    home.packages = [ pkgs.firefox-beta ];
  };
}
