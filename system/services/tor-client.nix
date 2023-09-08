{ config, lib, options, ... }:
with lib;
let
  cfg = config.jade.system.services.tor-client;
in
{
  options = {
    jade.system.services.tor-client = mkOption {
      description = "Tor client preferences";
      type = types.submodule {
        options = {
          enable = mkEnableOption "preconfigured Tor client";
        };
      };
    };
  };
  config = mkIf cfg.enable {
    # TOR 
    services.tor = {
      enable = true;
      client = {
        enable = true;
        socksListenAddress = {
          IsolateDestAddr = true;
          addr = "127.0.0.1";
          port = 9050;
        };
      };
    };
  };
}
