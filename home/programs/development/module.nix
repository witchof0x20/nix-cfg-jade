{ config, lib, options, osConfig, pkgs, ... }:
with lib;
let
  cfg = config.jade.home.development;
  nixpkgs-fmt = pkgs.nixpkgs-fmt;
in
{
  imports = [
    ./git.nix
  ];
  options = {
    jade.home.development = {
      enable = mkEnableOption "development presets";
    };
  };
  config = mkIf cfg.enable {
    # Programs that are often useful
    home.packages = with pkgs; [
      # This machine will be used as a nix workstation
      nix-prefetch-git
      # Random file tools
      dos2unix
      unixtools.xxd
      nixpkgs-fmt
    ];
    # Vim presets
    programs.vim.ale = {
      enable = true;
      fixOnSave = true;
      autoComplete.enable = true;
      fixers.nix = [ "nixpkgs-fmt" ];
    };
  };
}




