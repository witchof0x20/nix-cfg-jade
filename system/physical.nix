# Common config for all physical (non-vm) machines
{ config, lib, ... }:
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
}
