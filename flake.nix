{
  description = "Flake defining features I want on every system I use";

  inputs = { };

  outputs = { self }: rec {
    # This module is used for NixOS system config
    nixosModules.system = import ./system/module.nix;
    # This module is used for home-manager config
    homeModules.default = import ./home/module.nix;
  };
}
