{ config, lib, options, osConfig, pkgs, ... }:
with lib;
let
  cfg = config.jade.home;
in
{
  imports = [
    # TERMINAL PROGRAMS
    ## Vim
    ./programs/vim.nix
    ## Password management
    ./programs/passwords.nix
    ## Cybersec tools
    ./programs/cybersecurity.nix
    # DESKTOP PROGRAMS
    ## .XResources
    ./desktop/xresources.nix
    ## EasyEffects
    ./desktop/easyeffects.nix
    ## Slack
    ./desktop/slack.nix
    # DEVELOPMENT
    ./programs/development/module.nix
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




