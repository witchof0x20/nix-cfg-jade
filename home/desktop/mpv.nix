{ config, lib, pkgs, options, osConfig, ... }:
with lib;
let
  cfg = config.jade.home.programs.mpv;
in
{
  imports = [ ];
  # TODO: gate this behind wayland
  options = {
    jade.home.programs.mpv = {
      enable = mkOption {
        type = types.bool;
        default = osConfig.jade.system.graphical.enable;
        description = "Whether to enable mpv";
      };
    };
  };
  config = mkIf cfg.enable {
    programs.mpv = {
      enable = true;
      config = {
        pause = "yes";
        keep-open = "yes";
        border = "no";

        screenshot-format = "png";
        # TODO: use xdg
        screenshot-directory = "~/Pictures";

        volume-max = "200";

        alang = "jpn,jp,eng,en";
        slang = "eng,en";

        # display-resample-vdrop?;
        video-sync = "display-resample";
        opengl-pbo = "yes";
        #display-fps = "60.012001";

        profile = "opengl-hq";
        interpolation = "yes";
        deband = "no";
        #scale = "ewa_lanczossharp";
        #cscale = "ewa_lanczossharp";
        #tscale = "catmull_rom";
        #tscale = "oversample";

        #demuxer-mkv-subtitle-preroll = "yes # good?";
        blend-subtitles = "yes";
        sub-ass-vsfilter-aspect-compat = "no";
        sub-ass-force-style = "Kerning=yes";
        sub-gauss = "0.6";

        sub-font = "Noto Sans";
        sub-border-size = "3";
        sub-margin-x = "48";
        sub-margin-y = "48";
        sub-font-size = "48";

        x11-bypass-compositor = "yes";

        osd-fractions = "yes";
      };
    };
  };
}
