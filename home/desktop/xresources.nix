{ config, lib, pkgs, options, osConfig, ... }:
with lib;
let
  cfg = config.jade.home.program.xresources;
in
{
  imports = [ ];
  options = {
    jade.home.program.xresources = {
      # Enables Xresources management
      enable = mkOption {
        type = types.bool;
        default = osConfig.jade.system.graphical.enable;
        description = "Whether to manage .XResources";
      };
      # DPI 
      dpi = mkOption {
        type = types.int;
        description = "The monitor's DPI (calculate at https://dpi.lv)";
        default = 96;
      };
    };
  };
  config = mkIf cfg.enable {
    # .XResources
    xresources.properties = {
      # TODO: split into a config
      "Xft.rgba" = "rgb";
      "Xft.antialias" = 1;
      "Xft.hinting" = 1;
      "Xft.autohint" = 0;
      # Hinting amount (hintnone, hintslight, hintmedium, or hintfull)
      "Xft.hintstyle" = "hintslight";
      # LCD filter
      # TODO: whats this
      "Xft.lcdfilter" = "lcddefault";
      # DPI
      "Xft.dpi" = cfg.dpi;
    };
  };
}
