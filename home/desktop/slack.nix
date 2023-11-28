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
      # TODO assert that system wide chromium sandbox is avaiable
      systemd.user.services.slack = {
        Unit = {
          Description = "Desktop client for Slack";
          After = [ "graphical-session-pre.target" ];
          PartOf = [ "graphical-session.target" ];
        };
        Service = {
          Environment = "PATH=${config.home.profileDirectory}/bin";
          ExecStart = "${cfg.package}/bin/slack -u -s";
        };
        Install = {
          WantedBy = [ "graphical-session.target" ];
        };
      };
      home.packages = [
        cfg.package
      ];
    };
}
