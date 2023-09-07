# Interactive systems are systems I log into and do stuff on
# Usually means i'll need frequent shell access
# password function is a function that takes `config` and returns a path to a password file
{ config, pkgs, lib, options, ... }:
with lib;
let
  cfg_top = config.jade.system;
  cfg = cfg_top.interactive;
  is_physical = cfg_top.physical.enable;
in
{
  options = {
    # Whether the machine is an interactive system
    jade.system.interactive = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Indicates this system is interactive, which means I often need interactive shell access";
      };
      user = {
        name = mkOption {
          type = types.passwdEntry types.str;
          description = "The name of the main user of this machine";
          default = "jade";
        };
        description = mkOption {
          type = types.passwdEntry types.str;
          description = "Friendly name for the user";
          default = "Jade Harley";
        };
        passwordFile = mkOption {
          type = types.str;
          description = "Password file";
        };
      };
    };
  };
  config = mkIf (cfg_top.enable && cfg.enable) {
    # A user for me with login
    users.users."${cfg.user.name}" = {
      description = cfg.user.description;
      isNormalUser = true;
      extraGroups = [ "wheel" ];
      # TODO: consider making this an option or using null
      uid = 1000;
      passwordFile = cfg.user.passwordFile;
    };
    # Since this is a sudo user there's no shame in enabling trust
    nix.trustedUsers = mkAfter [ cfg.user.name ];
    # Internationalisation properties.
    i18n = {
      defaultLocale = "en_US.UTF-8";
      extraLocaleSettings = {
        LC_TIME = "en_GB.UTF-8";
      };
    };
    # Console settings
    console = {
      font = "Lat2-Terminus16";
      keyMap = "us";
    };
    # Enable bash completion
    programs.bash.enableCompletion = true;

    # Packages I would like to have when working on the system
    environment.systemPackages = with pkgs; [
      # For nslookup (todo is there a simpler one)
      bind
      # Figuring out the type of files
      file
      # For formatting disks
      gptfdisk
      # For tracking process usage
      htop
      # Of course we want man pages
      man-pages
      # For generating password hashes
      mkpasswd
      # Encryption, cert generation
      openssl
      # For watching transfer progress
      pv
      progress
      # Fancy rust grep
      ripgrep
      # Terminfo :pleading:
      alacritty.terminfo
      # For watching net traffic
      tcpdump
      # Terminal multiplexer
      tmux
      # Downloading
      aria2
      curl
      wget
      # Dns lookups
      dnsutils
    ] ++ optionals is_physical [
      # Getting things like ram, etc
      dmidecode
      # lspci
      pciutils
      # lsusb
      usbutils
    ];
  };
}
