{ packages, lix-nixos-module }: { config, lib, pkgs, options, ... }:
with lib;
let
  cfg = config.jade.system;
in
{
  imports = [
    lix-nixos-module.nixosModules.default
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
    # Services
    ##  DHCP options
    ./services/dhcp.nix
    ##  DNS options
    ./services/dns.nix
    ##  SSH options
    ./services/ssh.nix
    ## TOR options
    ./services/tor-client.nix
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
      # Nixpkgs flakes
      inputs = mkOption {
        type = types.attrsOf (types.attrs);
        description = "Nixpkgs flakes";
      };
    };
  };
  config = mkIf cfg.enable (
    let
      inputs = cfg.inputs;
    in
    {
      # Let 'nixos-version --json' know about the Git revision of this flake.
      system.configurationRevision = cfg.rev;
      # Overlay our custom packages
      # Add in packages
      nixpkgs.overlays = let system = config.nixpkgs.system; in [
        (self: super: {
          autoeq = packages.${system}.autoeq;
        })
      ];
      # Store our inputs
      _module.args.inputs = inputs;
      services.userborn.enable = true;
      # Set up our nix preferences
      nix = {
        # Auto-gc
        gc = {
          automatic = true;
          persistent = true;
          # We don't want to rule out all previous derivations because we might actually need to rollback
          # So we're making our gc runs that delete generations conservative [;) get it?]
          # in the default config that gets put on all machines
          options = "--delete-older-than 7d";
        };
        # Pin other channels
        registry = ((mapAttrs (name: flake: {
          inherit flake;
        })) inputs) // {
          nixpkgs.flake = cfg.nixpkgs;
        };
        # Handle nixPath
        nixPath = [
          "nixpkgs=${cfg.nixpkgs}"
        ] ++ (mapAttrsToList (name: flake: "${name}=${flake}") inputs);
        # Nice nix settings
        settings = {
          # Sandbox builds
          sandbox = true;
          # Optimise store
          auto-optimise-store = true;
          # Trust root and wheel
          trusted-users = pkgs.lib.mkAfter [ "root" "@wheel" ];
          # Enable flakes and commands
          experimental-features = [ "nix-command" "flakes" "auto-allocate-uids" ];
          # Auto allocate UIDs
          auto-allocate-uids = true;
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
      networking = {
        # By default, enable IPv6
        enableIPv6 = true;
        # Use temporary (privacy) addresses
        tempAddresses = "enabled";
        # Enable firewall with no ports by defualt
        firewall = {
          enable = true;
          allowedTCPPorts = [ ];
          allowedUDPPorts = [ ];
        };
      };
    }
  );
}
