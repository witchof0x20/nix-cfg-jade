{ config, lib, options, osConfig, pkgs, ... }:
with lib;
let
  cfg = config.jade.home;
in
{
  imports = [
    # .XResources
    ./xresources.nix
    # EasyEffects
    ./easyeffects.nix
  ];
  options = {
    jade.home = {
      # Main enabling option
      enable = mkEnableOption "a default set of configurations used for Jade's home-manager setup";
    };
  };
  config = mkIf cfg.enable {
    # Shell config
    programs.bash = {
      enable = true;
      enableVteIntegration = true;
      sessionVariables = {
        # TODO: refer to the specific version of vim created by the vim config
        EDITOR = "vim";
      };
      shellAliases = {
        # Shortcut for xdg-open
        # TODO: move this together with xdg
        open = "${pkgs.xdg-utils}/bin/xdg-open";
      };
      # TODO: move this maybe?
      initExtra = ''
        PS1="\[$(tput bold)\]\[\033[38;5;0m\]\[\033[48;5;10m\]\u@\h:\w$ \[$(tput sgr0)\] \[$(tput sgr0)\]"
      '';
    };
  };
}




