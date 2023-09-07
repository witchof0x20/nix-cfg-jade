# This machine is a desktop or laptop. Something with a graphical environment
{ config, pkgs, lib, ... }:
let
  cfg = config.jade.system.graphical;
in
lib.mkIf cfg.enable
{
  imports = [
    # Import pipewire config
    ./pipewire.nix
  ];

  # Desktop systems are always interactive
  jade.system.interactive = true;

  # Enable X11 (just enough to run wayland and a backup xterm session just in case)
  services.xserver = {
    enable = true;
    # Use gdm 
    displayManager.gdm = {
      enable = true;
      wayland = true;
    };
    displayManager.defaultSession = "sway";
    desktopManager.xterm.enable = true;
    # Fix screen tearing under x11
    deviceSection = ''
      Option "TearFree" "true"
    '';
  };

  # Enable OpenGL
  hardware.opengl = {
    enable = true;
  };
  # Color management service
  services.colord.enable = true;


  # Installed packages needed for desktop testing and use
  environment.systemPackages = with pkgs; [
    # Display utils
    glxinfo
    # Display drivers (TODO: still needed?)
    libGL
    mesa.drivers
    # TODO: i forget why this is needed
    glib
  ];

  # Configure fonts 
  fonts = {
    fontDir.enable = true;
    enableGhostscriptFonts = true;
    enableDefaultFonts = true;
    fontconfig = {
      enable = true;
      defaultFonts = {
        monospace = [ "Fira Code" ];
        emoji = [ "Font Awesome 5 Free" "Font Awesome 5 Brands" ];
        sansSerif = [ "DejaVu Sans" ];
        serif = [ "DejaVu Serif" ];
      };
    };
    fonts = with pkgs; [
      # Coding font 
      fira-code
      fira-code-symbols
      # Common fonds
      dejavu_fonts
      liberation_ttf_v2
      corefonts
      # For fancy symbols
      font-awesome_5
      # For japanese
      noto-fonts-cjk
    ];
  };


  # Stuff for yubikey
  services.udev.packages = [ pkgs.libu2f-host ];
  services.yubikey-agent.enable = true;

}
