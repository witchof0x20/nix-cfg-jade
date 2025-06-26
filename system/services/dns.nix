{ config, lib, options, pkgs, ... }:
with lib;
let
  unbound_addr = "127.0.0.1";
  dnscrypt_addr = "127.0.0.72";
  cfg = config.jade.system.services.dns;
  dnsResolvers = {
    quad9 = {
      domain = "dns.quad9.net";
      resolvers = {
        v4 = [ "9.9.9.9" "149.112.112.112" ];
        v6 = [ "2620:fe::fe" "2620:fe::9" ];
      };
    };
    quad9_no_blocking = {
      domain = "dns10.quad9.net";
      resolvers = {
        v4 = [ "9.9.9.10" "149.112.112.10" ];
        v6 = [ "2620:fe::10" "2620:fe::fe:10" ];
      };
    };
    quad9_secure_ecs = {
      domain = "dns11.quad9.net";
      resolvers = {
        v4 = [ "9.9.9.11" "149.112.112.11" ];
        v6 = [ "2620:fe::11" "2620:fe::fe:11" ];
      };
    };
    quad9_no_blocking_ecs = {
      domain = "dns12.quad9.net";
      resolvers = {
        v4 = [ "9.9.9.12" "149.112.112.12" ];
        v6 = [ "2620:fe::12" "2620:fe::fe:12" ];
      };
    };
  };
  generateResolverList =
    { names
    , useV4 ? true
    , useV6 ? true
    , port ? 853
    , resolversMap ? dnsResolvers
    }:
    let
      # Helper function to process a single resolver entry
      processResolver = name:
        if builtins.hasAttr name resolversMap then
          let
            config = resolversMap.${name};
            domain = config.domain;

            # Get IPv4 addresses if requested
            v4Entries =
              if useV4 && builtins.hasAttr "v4" config.resolvers
              then map (ip: "${ip}@${toString port}#${domain}") config.resolvers.v4
              else [ ];

            # Get IPv6 addresses if requested
            v6Entries =
              if useV6 && builtins.hasAttr "v6" config.resolvers
              then map (ip: "${ip}@${toString port}#${domain}") config.resolvers.v6
              else [ ];
          in
          v4Entries ++ v6Entries
        else
          [ ];
    in
    builtins.concatLists (map processResolver names);
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
    # Set up resolved to use our resolvers by default
    systemd.resolved = {
      enable = true;
      extraConfig = ''
        DNS=${unbound_addr} ${dnscrypt_addr}
      '';
    };
    # Local DNS server
    services.unbound = {
      enable = true;
      #resolveLocalQueries = true;
      package = pkgs.unbound-full.override {
        withRedis = false;
      };
      enableRootTrustAnchor = true;
      settings = {
        server = {
          do-not-query-localhost = false;
          aggressive-nsec = true;
          cache-max-ttl = 14400;
          cache-min-ttl = 1200;
          do-ip4 = true;
          do-ip6 = true;
          do-tcp = true;
          hide-identity = true;
          hide-version = true;
          # TODO: consider caps-id
          # Prefetching
          prefetch = true;
          prefetch-key = true;
        };
        forward-zone = [
          {
            name = ".";
            # Quad9 (no blocking)  
            forward-tls-upstream = true;
            forward-addr = (generateResolverList { names = [ "quad9_no_blocking" ]; });
          }
        ];
      };
    };
    services.dnscrypt-proxy2 = {
      enable = true;
      settings = {
        listen_addresses = [ "${dnscrypt_addr}:53" ];
        ipv6_servers = true;
        server_names = [ "quad9-doh-ip4-port443-nofilter-pri" "quad9-doh-ip6-port443-nofilter-pri" ];
      };
    };
  };
}
