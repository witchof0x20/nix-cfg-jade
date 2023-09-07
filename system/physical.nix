# Common config for all physical (non-vm) machines
{ config, lib, ... }:
with lib;
{
  options = {
    # Whether the machine is physical
    jade.system.physical = {
      enable = mkOption {
        type = types.bool;
        default = config.jade.system.enable;
        description = "Indicates this system is physical (i.e. not a VM)";
      };
      # Whether the machine is Intel or AMD
      processor = mkOption {
        type = types.enum [ "intel" "amd" ];
        description = "Type of processor";
      };
    };
  };
  config =
    let
      cfg = config.jade.system.physical;
    in
    {
      # Enable the acpi daemon
      services.acpid.enable = cfg.enable;
      # Set to update microcode based on cpu
      hardware.cpu = {
        intel.updateMicrocode = (cfg.processor == "intel");
        amd.updateMicrocode = (cfg.processor == "amd");
      };
    };
}
