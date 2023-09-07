# Interactive systems are systems I log into and do stuff on
# Usually means i'll need frequent shell access
# password function is a function that takes `config` and returns a path to a password file
{ config, pkgs, lib, ... }:
let
  cfg = config.jade.interactive;
  is_physical = config.jade.physical.enable;
in
{
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
  nix.trustedUsers = lib.mkAfter [ cfg.user.name ];
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
  ] ++ lib.optionals is_physical [
    # Getting things like ram, etc
    dmidecode
    # lspci
    pciutils
    # lsusb
    usbutils
  ];
}
