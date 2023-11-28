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
      userEmail = cfg.user.email;
      userName = cfg.user.name;
      signing = {
        signByDefault = true;
        key = cfg.user.signingKey;
      };
      lfs.enable = true;
      ignores = [ "*~" "*.swp" ];
      extraConfig.init.defaultBranch = "main";
    };
  };
}
