# This machine is a desktop or laptop. Something with a graphical environment
{ config, lib, options, pkgs, ... }:
with lib;
let
  cfg = config.jade.system.graphical;
  cfg_phys = config.jade.system.physical;
in
{
  options = {
    # Whether the machine is used with a gui 
    jade.system.graphical = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Indicates this system should have a graphical environment";
      };
    };
  };
  imports = [
    # Import pipewire config
    ./pipewire.nix
    # Import scheduler
    ./scheduler.nix
  ];
  config = mkIf cfg.enable {
    # Enable X11 (just enough to run wayland and a backup xterm session just in case)
    services.xserver = {
      enable = true;
      # Fix screen tearing under x11
      #deviceSection = ''
      #  Option "TearFree" "true"
      #'';
    };
    # Enable graphics acceleration
    hardware.graphics = {
      enable = true;
    };
    # Color management service
    services.colord.enable = true;


    # Installed packages needed for desktop testing and use
    environment.systemPackages = with pkgs; [
      # Display utils
      mesa-demos
      # Display drivers (TODO: still needed?)
      libGL
      mesa
      # TODO: i forget why this is needed
      glib
    ];

    # Configure fonts 
    fonts = {
      fontDir.enable = true;
      enableGhostscriptFonts = true;
      enableDefaultPackages = true;
      fontconfig = {
        enable = true;
        defaultFonts = {
          monospace = [ "Fira Code" ];
          emoji = [ "Font Awesome 6 Free" "Font Awesome 6 Brands" ];
          sansSerif = [ "DejaVu Sans" ];
          serif = [ "DejaVu Serif" ];
        };
      };
      packages = with pkgs; [
        # Coding font 
        fira-code
        fira-code-symbols
        # Common fonds
        dejavu_fonts
        liberation_ttf_v2
        corefonts
        # For fancy symbols
        font-awesome
        # For japanese
        noto-fonts-cjk-sans
      ];
    };


    # Stuff for yubikey
    services.udev.packages = [ pkgs.libu2f-host ];
    services.yubikey-agent.enable = true;

    # TODO: presumably some of these are suitable for other processors.
    hardware.graphics.extraPackages = mkIf cfg_phys.enable (with pkgs; optionals (cfg_phys.processor == "intel") [
    ]);
  };
}
