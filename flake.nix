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
    packages.x86_64-linux.test =
      let
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        eval = import (nixpkgs.legacyPackages.x86_64-linux.path + "/nixos/lib/eval-config.nix") {
          baseModules = [
            nixosModules.system
          ];
          modules = [ ];
        };
      in
      pkgs.nixosOptionsDoc {
        options = eval.options;
      };
  };
}
