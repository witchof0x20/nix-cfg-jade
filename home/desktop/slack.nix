{ config, lib, pkgs, options, osConfig, ... }:
with lib;
let
  cfg = config.jade.home.programs.slack;
in
{
  options = {
    jade.home.programs.slack = {
      enable = mkEnableOption "Slack";
    };
  };
  config =
    let
      slack = pkgs.slack;
    in
    mkIf cfg.enable {
      systemd.user.services.slack = {
        Unit = {
          Description = "Desktop client for Slack";
          After = [ "graphical-session-pre.target" ];
          PartOf = [ "graphical-session.target" ];
        };
        Service = {
          Environment = "PATH=${config.home.profileDirectory}/bin";
          ExecStart = "${slack}/bin/slack -u -s";
        };
        Install = {
          WantedBy = [ "graphical-session.target" ];
        };
      };
      home.packages = [
        slack
      ];
    };
}
