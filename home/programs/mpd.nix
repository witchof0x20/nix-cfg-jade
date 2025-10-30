{ config, lib, pkgs, options, osConfig, ... }:
with lib;
let
  cfg = config.jade.home.programs.mpd;
  mpc_cli = pkgs.mpc;
in
{
  options = {
    jade.home.programs.mpd = {
      enable = mkEnableOption "Music Player Daemon";
      host = mkOption {
        type = types.str;
        description = "MPD host with samba share and main mpd instance";
      };
      enableNcmpcpp = mkEnableOption "ncmpcpp";
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
      enable = cfg.enableNcmpcpp;
      mpdMusicDir = null;
    };
    # TODO: gate this behind sway or wayland support
    home.packages = [ mpc_cli ];
    wayland.windowManager.sway.config.keybindings =
      let
        mpc = "${mpc_cli}/bin/mpc";
      in
      {
        "XF86AudioPlay" = "exec ${mpc} toggle";
        "XF86AudioPrev" = "exec ${mpc} prev";
        "XF86AudioNext" = "exec ${mpc} next";
      };
  };
}
