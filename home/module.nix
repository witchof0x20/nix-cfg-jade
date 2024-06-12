packages: { config, lib, options, osConfig, pkgs, ... }:
with lib;
let
  cfg = config.jade.home;
in
{
  imports = [
    # TERMINAL PROGRAMS
    ## Vim
    ./programs/vim.nix
    ## Tmux
    ./programs/tmux.nix
    ## MPD
    ./programs/mpd.nix
    ## Password management
    ./programs/passwords.nix
    ## Cybersec tools
    ./programs/cybersecurity.nix

    # DEVELOPMENT
    ./programs/development/module.nix

    # DESKTOP SETUP
    ./desktop/easyeffects.nix
    ./desktop/mako.nix
    ./desktop/themes.nix
    ./desktop/xresources.nix

    # DESKTOP PROGRAMS
    ./desktop/alacritty.nix
    ./desktop/chromium.nix
    ./desktop/firefox.nix
    ./desktop/mpv.nix
    ./desktop/slack.nix
  ];
  options = {
    jade.home = {
      # Main enabling option
      enable = mkEnableOption "a default set of configurations used for Jade's home-manager setup";
    };
  };
  config = mkIf cfg.enable {
    # Add in packages
    nixpkgs.overlays = let system = config.nixpkgs.system; in [
      (self: super: {
        autoeq = pkgs.callPackage packages.${system}.autoeq { };
        ee-framework-presets = pkgs.callPackage packages.${system}.ee-framework-presets { };
      })
    ];
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
