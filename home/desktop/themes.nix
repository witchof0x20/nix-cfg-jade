{ config, lib, pkgs, options, osConfig, ... }:
with lib;
let
  cfg = config.jade.home.program.themes;
in
{
  imports = [ ];
  options = {
    jade.home.program.themes = {
      enable = mkOption {
        type = types.bool;
        default = osConfig.jade.system.graphical.enable;
        description = "Whether to set theming";
      };
    };
  };
  config = mkIf cfg.enable {

    home.packages = with pkgs; [
      # gtk stuff
      gtk-engine-murrine
      gtk_engines
      gsettings-program-schemas
      lxappearance
    ];
    gtk = {
      enable = true;
      #cursorTheme = {
      #  package = pkgs.openzone-cursors;
      #  name = "Openzone Black";
      #};
      theme = {
        package = pkgs.sweet;
        name = "Sweet-Dark";
      };
    };
  };
}
