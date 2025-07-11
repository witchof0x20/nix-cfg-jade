{
  description = "Flake defining features I want on every system I use";

  inputs = {
    # It is highly recommended that you override this with your own nixpkgs. I don't update this repo often
    nixpkgs.url = github:NixOS/nixpkgs/master;
    # We use nur here, but you should override this, I don't update it often
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Simple systems import
    systems.url = "github:nix-systems/x86_64-linux";
    # yeah fuck it, lets use lix why not
    lix-nixos-module = {
      url = "git+https://git.lix.systems/lix-project/nixos-module.git?ref=release-2.91";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
      };
    };
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
  };

  outputs = { self, nixpkgs, flake-utils, lix-nixos-module, nur, autoeq, ... }: {
    # This module is used for NixOS system config
    nixosModules.system = import ./system/module.nix {
      packages = self.packages;
      lix-nixos-module = lix-nixos-module;
    };
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
      };
  }));
}
