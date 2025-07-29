{ config, lib, pkgs, options, osConfig, ... }:
with lib;
let
  cfg = config.jade.home.themes;
in
{
  imports = [ ];
  options = {
    jade.home.themes = {
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
      gsettings-desktop-schemas
      lxappearance
    ];
    gtk = {
      enable = true;
      # TODO: check if individual gtk versions need cursors
      cursorTheme = {
        package = pkgs.openzone-cursors;
        name = "Openzone Black";
        size = 16;
      };
      # TODO: check if individual versions need theme
      theme = {
        package = pkgs.orchis-theme;
        name = "Orchis-Dark";
      };
      # TODO: Font is already set elsewhere, should be preserved but check anyway
      gtk2.enable = true;
      gtk3 = {
        enable = true;
        extraConfig = {
          gtk-application-prefer-dark-theme = true;
        };
      };
      gtk4 = {
        enable = true;
        extraConfig = {
          gtk-application-prefer-dark-theme = true;
        };
      };
    };
    qt = {
      enable = true;
      platformTheme.name = "gtk3";
    };
    home.pointerCursor = {
      gtk.enable = true;
      x11.enable = true;
      package = pkgs.catppuccin-cursors.mochaPeach;
      name = "Catppuccin-Mocha-Peach-Cursors";
      size = 20;
    };
    # Prefer dark mode
    dconf =
      {
        settings = {
          "org/gnome/desktop/interface" = {
            color-scheme = "prefer-dark";
          };
        };
      };
  };
}
