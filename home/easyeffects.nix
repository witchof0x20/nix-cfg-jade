{ config, lib, pkgs, options, osConfig, ... }:
with lib;
let
  cfg = config.jade.home.easyeffects;
in
{
  imports = [ ];
  options = {
    jade.home.easyeffects = {
      enable = mkOption {
        type = types.bool;
        default = osConfig.jade.system.graphical.enable;
        description = "Whether to enable EasyEffects";
      };
    };
  };
  config = mkIf cfg.enable {
    # Enable the service
    services.easyeffects = {
      enable = true;
      preset = "flat";
    };
    # Create an immutable preset
    xdg.configFile."easyeffects/output/flat.json" = {
      enable = true;
      text = builtins.toJSON {
        output = {
          blocklist = [ ];
          plugin_order = [ ];
        };
      };
    };
  };
}
