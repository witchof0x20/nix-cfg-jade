# Common config for all physical (non-vm) machines
{ config, lib, options, pkgs, ... }:
with lib;
let
  cfg = config.jade.system.physical;
in
{
  options = {
    jade.system.physical = mkOption {
      description = "Configuration for physical (i.e. not a container) machines";
      type = types.submodule {
        options = {
          # Whether the machine is physical
          enable = mkOption {
            type = types.bool;
            default = config.jade.system.enable;
            description = "Indicates this system is physical";
          };
          # Whether the machine is Intel or AMD
          processor = mkOption {
            type = types.enum [ "intel" "amd" ];
            description = "Type of processor";
          };
        };
      };
    };
  };
  config = mkIf cfg.enable {
    # Enable the acpi daemon
    services.acpid.enable = cfg.enable;
    # Set to update microcode based on cpu
    hardware.cpu = {
      intel.updateMicrocode = (cfg.processor == "intel");
      amd.updateMicrocode = (cfg.processor == "amd");
    };
    hardware.opengl.extraPackages = with pkgs; optionals (cfg.processor == "intel") [
      vaapiIntel
      vaapiVdpau
      libvdpau-va-gl
    ];
  };
}
