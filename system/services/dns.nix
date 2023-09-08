{ config, lib, options, ... }:
with lib;
let
  cfg = config.jade.system.services.dns;
in
{
  options = {
    jade.system.services.dns = mkOption {
      description = "Custom DNS settings";
      type = types.submodule {
        options = {
          enable = mkEnableOption "Custom DNS";
        };
      };
    };
  };
  config = mkIf cfg.enable {
    # Local DNS server
    services.unbound = {
      enable = true;
      resolveLocalQueries = true;
      package = pkgs.unbound-full.override {
        withRedis = false;
      };
      enableRootTrustAnchor = true;
      settings = {
        server = {
          aggressive-nsec = true;
          cache-max-ttl = 14400;
          cache-min-ttl = 1200;
          do-ip4 = true;
          do-ip6 = true;
          do-tcp = true;
          hide-identity = true;
          hide-version = true;
        };
        forward-zone = [
          # Use cloudflare or google for upstream dns
          {
            name = ".";
            forward-tls-upstream = true;
            forward-addr = [
              "1.0.0.1@853#one.one.one.one"
              "1.1.1.1@853#one.one.one.one"
              "8.8.4.4@853#dns.google"
              "8.8.8.8@853#dns.google"
            ];
          }
        ];
      };
    };
  };
}
