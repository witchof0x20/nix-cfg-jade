{ config, lib, pkgs, options, ... }:
with lib;
let
  cfg = config.jade.home.vim;
in
{
  imports = [
    ./ale_config.nix
  ];
  options = {
    jade.home.vim = {
      enable = mkEnableOption "Vim";
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
          set clipboard=unnamedplus
          set softtabstop=${builtins.toString tab_width}
          set exrc
          set secure
          " Terminal titles
          set title
        '';
        ale = {
          enable = true;
          fixOnSave = true;
          autoComplete.enable = true;
          fixers.nix = [ "nixpkgs-fmt" ];
        };
      };
    # Add vim as default editor
    programs.bash.sessionVariables = {
      EDITOR = "${config.home.programs.vim.package}/bin/vim";
    };
  };
}
