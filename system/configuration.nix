# This file goes in every system. It should contain extremely generic but necessary configs
{ config, pkgs, lib, ... }:
{
  # Nix config
  nix = {
    # Use flakes
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    # Sandbox builds
    useSandbox = true;
    # Optimise store
    autoOptimiseStore = true;
    # Auto-gc
    gc = {
      automatic = true;
      persistent = true;
      # We don't want to rule out all previous derivations because we might actually need to rollback
      # So we're making our gc runs that delete generations conservative [;) get it?]
      # in the default config that gets put on all machines
      options = "--delete-older-than 7d";
    };
    # Trust root and wheel
    settings.trusted-users = pkgs.lib.mkAfter [ "root" "@wheel" ];
  };
  # Clean up /tmp on boot
  boot.cleanTmpDir = true;
  # Internationalisation properties.
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_TIME = "en_GB.UTF-8";
    };
  };
  # Console settings
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };
  # We always want to use immutable users
  users.mutableUsers = false;
}
