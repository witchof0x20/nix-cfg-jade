{ config, lib, pkgs, options, osConfig, ... }:
with lib;
let
  cfg = config.jade.home.programs.chromium;
in
{
  imports = [ ];
  options = {
    jade.home.programs.chromium = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to enable Chromium";
      };
    };
  };
  config = mkIf cfg.enable {
    # TODO assert that system wide chromium sandbox is avaiable
    home.packages = [
      pkgs.chromium
    ];
    programs.chromium = {
      enable = true;
      extensions = [
        # uBlock Origin
        "cjpalhdlnbpafiamejdnhcphjbkeiagm"
      ];
    };
  };
}
