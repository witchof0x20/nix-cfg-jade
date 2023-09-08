{ lib, pkgs, config, ... }:
with lib;
let
  cfg = config.programs.vim.ale;
in
{
  options.programs.vim.ale = {
    enable = mkEnableOption "ALE plugin for vim";
    fixOnSave = mkOption {
      type = types.bool;
      description = "Whether to run fixers on save";
      default = false;
    };
    autoComplete.enable = mkEnableOption "autocomplete";
    fixers = mkOption {
      type = types.attrsOf (types.listOf types.string);
      description = "Fixers to use for ALE";
      default = { };
    };
    linters = mkOption {
      type = types.attrsOf (types.listOf types.string);
      description = "Linters to use for ALE";
      default = { };
    };
  };

  config = mkIf cfg.enable {
    programs.vim = {
      plugins = with pkgs.vimPlugins; [
        ale
      ];
      extraConfig = mkAfter ''
        let g:ale_fixers = ${builtins.toJSON cfg.fixers}
        let g:ale_linters = ${builtins.toJSON cfg.linters}
        ${optionalString (cfg.fixOnSave) "let g:ale_fix_on_save = 1"}
        ${optionalString (cfg.autoComplete.enable) "let g:ale_completion_enabled = 1"}
      '';
    };
  };
}



