{ config, lib, pkgs, options, osConfig, ... }:
with lib;
let
  cfg = config.jade.home.programs.password_management;
in
{
  options = {
    jade.home.programs.password_management = {
      enable = mkEnableOption "tools for password and credential management";
    };
  };
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      pwgen
      pass
      gnupg
    ];
    programs.password-store = {
      enable = true;
      settings = {
        PASSWORD_STORE_GENERATED_LENGTH = "64";
        PASSWORD_STORE_CLIP_TIME = "15";
      };
    };
    services.gpg-agent = {
      enable = true;
      pinentryFlavor = "gtk2";
    };
    services.gnome-keyring.enable = true;
  };
}
