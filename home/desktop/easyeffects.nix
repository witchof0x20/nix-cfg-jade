{ config, lib, pkgs, options, osConfig, ... }:
with lib;
let
  cfg = config.jade.home.programs.easyeffects;
  autoeq = pkgs.autoeq;
  # EasyEffects >= 8.x reads presets and impulse responses from
  # $XDG_DATA_HOME/easyeffects and resolves convolver kernels by
  # name (file stem) from the irs directory
  mkConvolverPreset = { kernelName, outputGain }: builtins.toJSON {
    output = {
      blocklist = [ ];
      plugins_order = [ "convolver#0" ];
      "convolver#0" = {
        "input-gain" = 0.0;
        "ir-width" = 100;
        "kernel-name" = kernelName;
        "output-gain" = outputGain;
      };
    };
  };
  # force = true because easyeffects 8.x migrates presets it finds in
  # the old ~/.config/easyeffects location into XDG_DATA_HOME as plain
  # files, which would otherwise block home-manager activation
  mkDataFile = attrs: attrs // { force = true; };
in
{
  imports = [ ];
  options = {
    jade.home.programs.easyeffects = {
      enable = mkOption {
        type = types.bool;
        default = osConfig.jade.system.graphical.enable;
        description = "Whether to enable EasyEffects";
      };
    };
  };
  config = mkIf cfg.enable {
    # Enable the service
    services.easyeffects = {
      enable = true;
      preset = "flat";
    };
    # Create an immutable preset that does nothing
    xdg.dataFile."easyeffects/output/flat.json" = mkDataFile {
      text = builtins.toJSON {
        output = {
          blocklist = [ ];
          plugins_order = [ ];
        };
      };
    };
    # Create another immutable preset for my ath-m50x
    xdg.dataFile."easyeffects/output/ATH-m50x.json" = mkDataFile {
      text = mkConvolverPreset {
        kernelName = "ath-m50x-velour-48000";
        outputGain = -4.1;
      };
    };
    # Preset for the Sennheiser HD 599 (SE); output gain is the
    # AutoEq recommended preamp
    xdg.dataFile."easyeffects/output/HD599SE.json" = mkDataFile {
      text = mkConvolverPreset {
        kernelName = "hd-599-48000";
        outputGain = -6.3;
      };
    };
    # Impulse responses (easyeffects requires the .irs extension)
    xdg.dataFile."easyeffects/irs/ath-m50x-velour-48000.irs" = mkDataFile {
      source = "${autoeq}/share/autoeq/ath-m50x-velour-48000.wav";
    };
    xdg.dataFile."easyeffects/irs/hd-599-48000.irs" = mkDataFile {
      source = "${autoeq}/share/autoeq/hd-599-48000.wav";
    };
    home.packages = [ autoeq ];
  };
}
