{ config, lib, pkgs, options, osConfig, ... }:
with lib;
let
  cfg = config.jade.home.programs.easyeffects;
  autoeq = pkgs.autoeq;
  irs_relative_path = "easyeffects/irs/ath-m50x-velour-48000.irs";
in
{
  imports = [ ];
  options = {
    jade.home.programs.easyeffects = {
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
    # Create an immutable preset that does nothing
    xdg.configFile."easyeffects/output/flat.json" = {
      enable = true;
      text = builtins.toJSON {
        output = {
          blocklist = [ ];
          plugins_order = [ ];
        };
      };
    };
    # Create another immutable preset for my ath-m50x
    xdg.configFile."easyeffects/output/ATH-m50x.json" = {
      enable = true;
      text = builtins.toJSON {
        output = {
          blocklist = [ ];
          plugins_order = [ "convolver" ];
          convolver = {
            "input-gain" = 0.0;
            "ir-width" = 100;
            "kernel-path" = "${config.xdg.configHome}/${irs_relative_path}";
            "output-gain" = -4.1;
          };
        };
      };
    };
    xdg.configFile.${irs_relative_path} = {
      enable = true;
      source = "${autoeq}/share/autoeq/ath-m50x-velour-48000.wav";
    };
    home.packages = [ autoeq ];
  };
}
