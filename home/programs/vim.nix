{ config, lib, pkgs, options, osConfig, ... }:
with lib;
let
  cfg = config.jade.home.programs.vim;
in
{
  imports = [
    ./ale_config.nix
  ];
  options = {
    jade.home.programs.vim = {
      enable = mkOption {
        type = types.bool;
        default = osConfig.jade.system.interactive.enable;
        description = "Whether to enable fancy vim config for the home user";
      };
    };
  };
  config = mkIf cfg.enable {
    # Vim config
    programs.vim =
      let
        tab_width = 2;
      in
      {
        enable = true;
        settings = {
          number = true;
          background = "dark";
          expandtab = true;
          mouse = "a";
          tabstop = tab_width;
          shiftwidth = tab_width;
        };
        extraConfig = ''
          set softtabstop=${builtins.toString tab_width}
          set exrc
          set secure
          " Terminal titles
          set title
        '';
      };
    # Add vim as default editor
    programs.bash.sessionVariables = {
      EDITOR = "${config.programs.vim.package}/bin/vim";
    };
    # Ignore vim stuff in git
    programs.git.ignores = [ "*~" "*.swp" ];
  };
}
