{ config, lib, options, osConfig, pkgs, ... }:
with lib;
let
  cfg = config.jade.home.development;
  nixpkgs-fmt = pkgs.nixpkgs-fmt;
in
{
  imports = [
    ./git.nix
    ./ssh.nix
  ];
  options = {
    jade.home.development = {
      enable = mkEnableOption "development presets";
    };
  };
  config = mkIf cfg.enable {
    # Programs that are often useful
    home.packages = with pkgs; [
      # Filesystem tools
      sshfs
      # This machine will be used as a nix workstation
      nix-prefetch-git
      # Random file tools
      dos2unix
      unixtools.xxd
      nixpkgs-fmt
      # Flashing tools
      woeusb
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




