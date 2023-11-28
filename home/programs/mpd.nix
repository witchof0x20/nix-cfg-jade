{ config, lib, pkgs, options, osConfig, ... }:
with lib;
let
  cfg = config.jade.home.programs.mpd;
in
{
  options = {
    jade.home.programs.mpd = {
      enable = mkEnableOption "Music Player Daemon";
      host = mkOption {
        type = types.str;
        description = "MPD host with samba share and main mpd instance";
      };
    };
  };
  config = mkIf cfg.enable {
    services.mpd = {
      enable = true;
      musicDirectory = "smb://${cfg.host}/music";
      dbFile = null;
      extraConfig = ''
        database {
          plugin  "proxy"
          host    "${cfg.host}"
          port    "6600"
        }
        audio_output {
          type "pipewire"
          name "Pipewire"
        }
      '';
    };
    programs.ncmpcpp = {
      enable = true;
      mpdMusicDir = null;
    };
    # TODO: gate this behind sway or wayland support
    home.packages = [ pkgs.mpc_cli ];
    wayland.windowManager.sway.config.keybindings = {
      "XF86AudioPlay" = "exec ${pkgs.mpc_cli}/bin/mpc toggle";
    };
  };
}
