# Common config for all physical (non-vm) machines
{ config, lib, options, ... }:
with lib;
let
  cfg = config.jade.system.security;
in
{
  options = {
    jade.system.security = mkOption {
      description = "Custom security options";
      type = types.submodule {
        options = {
          blacklist_me = mkOption {
            type = types.bool;
            default = false;
            description = "Whether to blacklist the Intel ME kernel driverss";
          };
        };
      };
    };
  };
  config = {
    boot.blacklistedKernelModules = lib.optionals cfg.blacklist_me [ "mei" "mei_me" ];
  };
}
