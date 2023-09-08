{ config, lib, pkgs, options, ... }:
with lib;
let
  cfg = config.jade.system;
in
{
  imports = [
    # Unfree package config
    ./unfree.nix
    # Security config
    ./security.nix
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
  options = {
    jade.system = {
      # Main enabling option
      enable = mkEnableOption "a default set of configurations used on all Jade's systems";
      # Main nixpkgs flake
      nixpkgs = mkOption {
        type = types.attrs;
        description = "Main nixpkgs flake for the system";
      };
      # Revision
      rev = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "Revision of the flake calling this flake. Used to store the system's revision";
      };
    };
  };
  config = mkIf cfg.enable {
    # Let 'nixos-version --json' know about the Git revision of this flake.
    system.configurationRevision = cfg.rev;
    # Set up our nix preferences
    nix = {
      # Use flakes
      package = pkgs.nixFlakes;
      extraOptions = ''
        experimental-features = nix-command flakes
      '';
      # Auto-gc
      gc = {
        automatic = true;
        persistent = true;
        # We don't want to rule out all previous derivations because we might actually need to rollback
        # So we're making our gc runs that delete generations conservative [;) get it?]
        # in the default config that gets put on all machines
        options = "--delete-older-than 7d";
      };
      # Pin nixpkgs to the system nixpkgs
      registry.nixpkgs.flake = cfg.nixpkgs;
      nixPath = [
        "nixpkgs=${cfg.nixpkgs}"
      ];
      settings = {
        # Sandbox builds
        sandbox = true;
        # Optimise store
        auto-optimise-store = true;
        # Trust root and wheel
        trusted-users = pkgs.lib.mkAfter [ "root" "@wheel" ];
      };
    };
    # Clean up /tmp on boot
    boot.tmp.cleanOnBoot = true;
    # Internationalisation properties.
    i18n = {
      defaultLocale = "en_US.UTF-8";
    };
    # We always want to use immutable users
    users.mutableUsers = false;
  };
}
