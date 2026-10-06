{ config, lib, pkgs, ... }:

let
  cfg = config.programs.plannotator;
  skillNames = [
    "plannotator"
    "plannotator-review"
    "plannotator-annotate"
    "plannotator-last"
  ];
in {
  options.programs.plannotator = {
    enable = lib.mkEnableOption "Plannotator and its shared agent skills";
    package = lib.mkPackageOption pkgs "plannotator" { };
    skills.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Install shared skills read by Codex, OpenCode, and Pi.";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ cfg.package ];

    # Manage individual skills so other installed skills remain independent.
    # Home Manager removes these links when the option is disabled.
    home.file = lib.mkIf cfg.skills.enable (lib.genAttrs
      (map (name: ".agents/skills/${name}") skillNames)
      (path: {
        source = "${cfg.package.skills}/share/plannotator/skills/${builtins.baseNameOf path}";
      }));
  };
}
