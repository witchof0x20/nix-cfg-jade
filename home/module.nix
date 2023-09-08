{ config, lib, pkgs, options, ... }:
with lib;
let
  cfg = config.jade.home;
in
{
  imports = [
    # .XResources
    ./xresources.nix
  ];
  options = {
    jade.home = {
      # Main enabling option
      enable = mkEnableOption "a default set of configurations used for Jade's home-manager setup";
    };
  };
  config = mkIf cfg.enable { };
}
