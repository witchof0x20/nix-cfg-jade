{ config, lib, pkgs, options, osConfig, ... }:
with lib;
let
  cfg = config.jade.home.alacritty;
in
{
  imports = [ ];
  options = {
    jade.home.alacritty = {
      enable = mkOption {
        type = types.bool;
        default = osConfig.jade.system.graphical.enable;
        description = "Whether to enable Alacritty";
      };
    };
  };
  config = mkIf cfg.enable {
    # Alacritty terminal config
    programs.alacritty = {
      enable = true;
      settings = {
        font = {
          normal = {
            family = "Fira Code";
            style = "regular";
          };
          size = 8.0;
        };
        dynamic_title = true;
        colors = {
          # Default colors
          primary = {
            background = "0x2D2A2E";
            foreground = "0xFCFCFA";
          };
          # Normal colors
          normal = {
            black = "0x403E41";
            red = "0xFF6188";
            green = "0xA9DC76";
            yellow = "0xFFD866";
            blue = "0xFC9867";
            magenta = "0xAB9DF2";
            cyan = "0x78DCE8";
            white = "0xFCFCFA";
          };
          # Bright colors
          bright = {
            black = "0x727072";
            red = "0xFF6188";
            green = "0xA9DC76";
            yellow = "0xFFD866";
            blue = "0xFC9867";
            magenta = "0xAB9DF2";
            cyan = "0x78DCE8";
            white = "0xFCFCFA";
          };
        };
      };
    };
  };
}
