{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.jade.system;
in
{
  options.jade.system = {
    # Main enabling option
    enable = mkEnableOption "a default set of configurations used on all Jade's systems";
    # Revision
    rev = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "Revision of the flake calling this flake. Used to store the system's revision";
    };
    # Whether the machine is physical
    physical = {
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
    # Unfree packages
    unfree = {
      # Whether to allow unfree packages
      enable = mkEnableOption "unfree packages";
      # The specific unfree packages to allow
      packageNames = mkOption {
        type = types.listOf types.str;
        default = [ ];
        description = "names of packages to allow";
      };
    };
    # Whether the machine is an interactive system
    interactive = {
      enable = mkOption {
        type = types.bool;
        default = config.jade.system.enable;
        description = "Indicates this system is interactive, which means I often need interactive shell access";
      };
      user = {
        name = mkOption {
          type = types.passwdEntry types.str;
          description = "The name of the main user of this machine";
          default = "jade";
        };
        description = mkOption {
          type = types.passwdEntry types.str;
          description = "Friendly name for the user";
          default = "Jade Harley";
        };
        passwordFile = mkOption {
          type = types.str;
          description = "Password file";
        };
      };
    };
    # Whether the machine is used with a gui 
    graphical = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Indicates this system should have a graphical environment";
      };
    };
    # Various services which can be turned on and off
    services = {
      # Options related to dhcp
      dhcp = {
        trust = mkOption {
          type = types.bool;
          default = false;
          description = "Whether to trust the system's dhcp";
        };
      };
      # Whether to enable ssh
      ssh = {
        enable = mkEnableOption "logging in via SSH";
      };
    };
  };
  imports = [
    # Generic options that must always be included
    ./configuration.nix
    # Unfree package config
    ./unfree.nix
    # Physical machine config
    ./physical.nix
    # Interactive machine config
    ./interactive.nix
    # Graphical machine config
    ./graphical/configuration.nix
    # DHCP options
    ./services/dhcp.nix
    # SSH options
    ./services/ssh.nix
  ];
  config = mkIf cfg.enable {
    # Let 'nixos-version --json' know about the Git revision of this flake.
    system.configurationRevision = cfg.rev;
    # Pin nixpkgs to the system nixpkgs
    nix = {
      registry.nixpkgs.flake = nixpkgs;
      nixPath = [
        "nixpkgs=${nixpkgs}"
      ];
    };
  };
}
