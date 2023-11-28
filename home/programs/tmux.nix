{ config, lib, pkgs, options, osConfig, ... }:
with lib;
let
  cfg = config.jade.home.programs.tmux;
in
{
  options = {
    jade.home.tmux = {
      enable = mkOption {
        type = types.bool;
        default = osConfig.jade.system.interactive.enable;
        description = "Whether to enable fancy tmux config";
      };
    };
  };
  config = mkIf cfg.enable {
    programs.tmux = {
      enable = true;
      clock24 = true;
      # tmux sessions don't survive logout.
      # don't use on server
      secureSocket = true;
      terminal = "screen-256color";
      extraConfig = ''
        set-option -g set-titles on
        set-option -g set-titles-string "#T"
        set-option -g automatic-rename on
        set-option -g automatic-rename-format "#T"
        set -g allow-rename off
      '';
    };
  };
}
