{ config, lib, pkgs, options, osConfig, ... }:
with lib;
let
  cfg = config.jade.home.programs.swaync;
in
{
  imports = [ ];
  options = {
    jade.home.programs.swaync = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to enable SwayNotificationCenter";
      };
    };
  };
  config = mkIf cfg.enable {
    services.swaync = {
      enable = true;
    };
    home.packages = with pkgs; [
      libnotify
    ];
  };
}
