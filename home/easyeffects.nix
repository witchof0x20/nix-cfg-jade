{ config, lib, pkgs, options, ... }:
with lib;
let
  cfg = config.jade.home.easyeffects;
in
{
  imports = [ ];
  options = {
    jade.home.easyeffects = {
      enable = mkEnableOption "EasyEffects";
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
