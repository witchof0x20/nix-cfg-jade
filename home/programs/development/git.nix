{ config, lib, pkgs, options, osConfig, ... }:
with lib;
let
  cfg_dev = config.jade.home.development;
  cfg = cfg_dev.git;
in
{
  options = {
    jade.home.development.git = {
      enable = mkEnableOption "fancy git config";
      user = {
        email = mkOption {
          type = types.str;
          description = "Git user email";
        };
        name = mkOption {
          type = types.str;
          description = "Git name";
        };
        signingKey = mkOption {
          type = types.str;
          description = "Git signing key";
        };
      };
    };
  };
  config = mkIf cfg_dev.enable {
    # Git config
    programs.git = {
      enable = true;
      signing = {
        signByDefault = true;
        key = cfg.user.signingKey;
      };
      lfs.enable = true;
      ignores = [ "*~" "*.swp" ];
      settings = {
        user = {
          email = cfg.user.email;
          name = cfg.user.name;
        };
        init.defaultBranch = "main";
      };
    };
  };
}
