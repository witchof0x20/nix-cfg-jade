{

  description = "Flake defining features I want on every system I use";

  inputs = {
    nixpkgs.url = github:nixos/nixpkgs/nixos-23.05;
  };

  outputs = { self, nixpkgs }: rec {
    # This module is used for NixOS system config
    nixosModules.system = import ./system/module.nix;
    # This module is used for home-manager config
    # homeModule = { config, lib, pkgs, ... }: { };
  };
}
