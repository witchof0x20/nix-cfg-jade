{ config, lib, options, ... }:
with lib;
let
  cfg = config.jade.system.unfree;
in
{
  options = {
    # Unfree packages
    jade.system.unfree = mkOption {
      description = "Unfree package config";
      type = types.submodule {
        options = {
          # Whether to allow unfree packages
          enable = mkEnableOption "unfree packages";
          # The specific unfree packages to allow
          packageNames = mkOption {
            type = types.listOf types.str;
            default = [ ];
            description = "names of packages to allow";
          };
          # Unfree packages to allow for alternative channels
          channels = mkOption {
            type = types.attrsOf (types.listOf types.str);
            description = "names of packages to allow per-channel";
          };
        };
      };
    };
  };
  config = mkIf cfg.enable
    ({ pkgs, lib, inputs, ... }: {
      # Permitted proprietary packages
      # TODO: figure out how to route this into a module
      nixpkgs.config.allowUnfreePredicate = (pkg: builtins.elem (lib.getName pkg) cfg.packageNames);
      # Import each of the channels using the predicate
      _module.args.channels = (mapAttrs
        (name: (flake: (import flake {
          inherit (pkgs) system;
          config = {
            allowUnfreePredicate = (pkg: builtins.elem (lib.getName pkg) cfg.channels.${name});
          };
        })))
        inputs);
    });
}
