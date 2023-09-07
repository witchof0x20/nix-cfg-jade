{ config, lib, options, ... }:
with lib;
let
  cfg = config.jade.system.unfree;
in
{
  options = {
    # Unfree packages
    jade.system.unfree = {
      # Whether to allow unfree packages
      enable = mkEnableOption "unfree packages";
      # The specific unfree packages to allow
      packageNames = mkOption {
        type = types.listOf types.str;
        default = [ ];
        description = "names of packages to allow";
      };
    };
  };
  config = mkIf cfg.enable {
    # Permitted proprietary packages
    # TODO: figure out how to route this into a module
    nixpkgs.config.allowUnfreePredicate = (pkg: builtins.elem (lib.getName pkg) cfg.packageNames);
  };
}
