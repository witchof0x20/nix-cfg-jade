{ config, lib, pkgs, options, osConfig, ... }:
with lib;
let
  cfg = config.jade.home.desktop.mako;
in
{
  imports = [ ];
  # TODO: gate this behind wayland
  options = {
    jade.home.desktop.mako = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to enable Mako";
      };
    };
  };
  config = mkIf cfg.enable {
    services.mako = {
      enable = true;
      defaultTimeout = 5000;
    };
    wayland.windowManager.sway.extraConfig = ''
      exec ${pkgs.mako}/bin/mako
    '';
    home.packages = with pkgs; [
      libnotify
    ];
  };
}
