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
      type = types.submodule {
        options = {
          blacklist_me = mkOption {
            type = types.submodule {
              options = {
                enable = mkEnableOption "whether to blacklist intel ME";
              };
            };
          };
          hardening = mkOption {
            description = "Hardening options";
            type = types.submodule {
              options = {
                enable = mkEnableOption "the NixOS hardening preset";
              };
            };
          };
          tcpcrypt = mkOption {
            description = "TCPcrypt options";
            type = types.submodule {
              options = {
                enable = mkEnableOption "tcpcrypt";
              };
            };
          };
        };
      };
    };
  };
  config = mkIf cfg_top.enable {
    #imports = optionals cfg.hardening.enable [
    #  "${registry.nixpkgs.flake}/nixos/modules/profiles/hardened.nix"
    #];
    boot.blacklistedKernelModules = mkAfter (optionals (cfg.blacklist_me.enable) [ "mei" "mei_me" ]);
    networking.tcpcrypt.enable = cfg.tcpcrypt.enable;
  };
  #// (mkIf cfg.hardening.enable {
  #  # Override some stuff from hardened
  #  environment.memoryAllocator.provider = "libc";
  #  # It's just too annoying to have to reboot on a laptop
  #  # TODO: put a laptop flag
  #  security.lockKernelModules = false;
  #}));
}
