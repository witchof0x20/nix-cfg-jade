{ config, lib, pkgs, options, osConfig, ... }:
with lib;
let
  cfg = config.jade.home.programs.slack;
in
{
  options = {
    jade.home.programs.slack = {
      enable = mkEnableOption "Slack";
      package = mkOption {
        type = types.package;
        default = pkgs.slack;
        defaultText = literalExpression "pkgs.slack";
        description = "Slack package to use";
      };
    };
  };
  config =
    let
      slack = pkgs.slack;
    in
    mkIf cfg.enable {
      home.packages = [
        cfg.package
      ];
    };
}
