{ config, lib, ... }:
let
  cfg = config.jade.system.unfree;
in
{
  # Permitted proprietary packages
  # TODO: figure out how to route this into a module
  nixpkgs.config.allowUnfreePredicate = lib.mkIf cfg.enable (pkg: builtins.elem (lib.getName pkg) cfg.packageNames);
}
