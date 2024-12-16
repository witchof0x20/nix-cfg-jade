{ config, lib, pkgs, options, osConfig, ... }:
with lib;
let
  cfg = config.jade.home.programs.firefox;
in
{
  imports = [ ];
  options = {
    jade.home.programs.firefox = {
      enable = mkOption {
        type = types.bool;
        default = osConfig.jade.system.graphical.enable;
        description = "Whether to enable Firefox";
      };
    };
  };
  config = mkIf cfg.enable {
    programs.firefox = {
      enable = true;
      package = pkgs.firefox-beta;
      profiles = {
        "default" = {
          isDefault = true;
          settings = {
            # Google Safe Browsing
            # Leaks the browsing history to Google. Note that disabling Safe Browsing
            # exposes you to a risk of not being stopped from visiting malicious or phishing sites.
            "browser.safebrowsing.enabled" = false;
            "browser.safebrowsing.downloads.enabled" = false;
            "browser.safebrowsing.malware.enabled" = false;
            # Firefox stats collecting
            # Stability and performance reports.
            "datareporting.healthreport.service.enabled" = false;
            "datareporting.healthreport.uploadEnabled" = false;
            # Usage statistics.
            "toolkit.telemetry.unified" = false;
            "toolkit.telemetry.enabled" = false;
            # Encrypted Media Extensions (DRM)
            # A binary plugin (closed-source) is shipped with Firefox since v38. It enables playback of encrypted media and lets you use e.g. Netflix without Microsoft Silverlight. To completely remove the plugin you would have to install an EME-free build of Firefox.
            "media.eme.enabled" = false;
            "media.gmp-eme-adobe.enabled" = false;
            # Firefox Hello
            # Firefox connects to third-party (Telefonica) servers without asking for permission.
            "loop.enabled" = false;
            # Pocket integration
            # A third-party service for managing a reading list of articles.
            "browser.pocket.enabled" = false;
            # Search suggestions
            # Everything you type in the search box is sent to the search engine. Suggestions based on local history will still work.
            "browser.search.suggest.enabled" = false;
            # Geolocation
            "geo.enabled" = false;
            # Adobe Flash
            "plugin.state.flash" = 0;
            # Disable the sponsored thing
            "browser.newtabpage.directory.source" = "";
            # Always restore tabs
            "browser.sessionstore.max_resumed_crashes" = -1;
            # Enable extensions enabled in nix
            "extensions.autoDisableScopes" = 0;
          };
          # Required extensions
          extensions = with pkgs.nur.repos.rycee.firefox-addons; [
            multi-account-containers
            sponsorblock
            stylus
            switchyomega
            ublock-origin
            umatrix
            violentmonkey
          ];
        };
      };
    };
  };
}




