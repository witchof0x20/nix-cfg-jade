{
  description = "Flake defining features I want on every system I use";

  inputs = {
    # Okay fine i'll import nixpkgs
    nixpkgs.url = github:NixOS/nixpkgs/master;
    # Simple systems import
    systems.url = "github:nix-systems/x86_64-linux";
    # Flake-utils for exporting packages
    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.systems.follows = "systems";
    };
    # Autoeq preset for headphones
    autoeq = {
      url = github:jaakkopasanen/AutoEq;
      flake = false;
    };
    # Equalizer presets for framework laptops
    ee-framework-presets = {
      url = github:ceiphr/ee-framework-presets;
      flake = false;
    };
  };

  outputs = { self, nixpkgs, flake-utils, autoeq, ee-framework-presets, ... }: {
    # This module is used for NixOS system config
    nixosModules.system = import ./system/module.nix self.packages;
    # This module is used for home-manager config
    # Pass in our packages
    homeModules.default = import ./home/module.nix;
  } // (flake-utils.lib.eachDefaultSystem (system: rec {
    packages =
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        autoeq = pkgs.callPackage (import ./packages/autoeq/default.nix autoeq) { };
        ee-framework-presets = pkgs.callPackage (import ./packages/ee-framework-presets/default.nix ee-framework-presets) {};
      };
  }));
}
