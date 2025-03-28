# Common config for all physical (non-vm) machines
{ config, lib, options, ... }:
with lib;
let
  cfg_top = config.jade.system;
  cfg = cfg_top.security;
in
{
  options = {
    jade.system.security = mkOption {
      description = "Custom security options";
      default = { };
      type = types.submodule {
        options = {
          blacklist_me = mkOption {
            default = { };
            type = types.submodule {
              options = {
                enable = mkEnableOption "whether to blacklist intel ME";
              };
            };
          };
          hardening = mkOption {
            description = "Hardening options";
            default = { };
            type = types.submodule {
              options = {
                enable = mkEnableOption "the NixOS hardening preset";
              };
            };
          };
          #          tcpcrypt = mkOption {
          #            description = "TCPcrypt options";
          #            type = types.submodule {
          #              options = {
          #                enable = mkEnableOption "tcpcrypt";
          #              };
          #            };
          #          };
        };
      };
    };
  };
  config = mkIf cfg_top.enable {
    # ME Blacklisting
    boot.blacklistedKernelModules = mkAfter (optionals (cfg.blacklist_me.enable) [ "mei" "mei_me" ]);

    # TCPCrypt
    #networking.tcpcrypt.enable = mkDefault cfg.tcpcrypt.enable;
    #users.users.tcpcryptd.group = mkIf cfg.tcpcrypt.enable "tcpcryptd";
    #users.groups.tcpcryptd = mkIf cfg.tcpcrypt.enable { };

    # TODO: figure out how to optionally import the hardening module
    environment.memoryAllocator.provider = mkIf cfg.hardening.enable "libc";
    # It's just too annoying to have to reboot on a laptop
    # TODO: put a laptop flag
    security.lockKernelModules = mkIf cfg.hardening.enable false;
  };
}
