{
  description = "Flake defining features I want on every system I use";

  inputs = {
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

  outputs = { self, flake-utils, autoeq, ee-framework-presets, ... }: {
    # This module is used for NixOS system config
    nixosModules.system = import ./system/module.nix self.packages;
    # This module is used for home-manager config
    # Pass in our packages
    homeModules.default = import ./home/module.nix;
  } // (flake-utils.lib.eachDefaultSystem (system: rec {
    packages = {
      autoeq = import ./packages/autoeq/default.nix autoeq;
      ee-framework-presets = import ./packages/ee-framework-presets/default.nix ee-framework-presets;
    };
  }));
}
