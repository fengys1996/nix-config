{ config, lib, pkgs, ... }:

let
  cfg = config.programs.lark-cli;
  autoUpdate = cfg.skills.enable && cfg.skills.autoUpdate.enable;
  updater = pkgs.writeShellApplication {
    name = "ai-update-lark-cli-skills";
    runtimeInputs = [ pkgs.coreutils pkgs.git pkgs.util-linux ];
    text = builtins.readFile ../scripts/ai-update-lark-cli-skills.sh;
  };
in {
  options.programs.lark-cli = {
    enable = lib.mkEnableOption "Lark CLI";
    skills = {
      enable = lib.mkEnableOption "the Lark CLI skills update command";
      autoUpdate.enable = lib.mkEnableOption "weekly Lark CLI skills updates";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.lark-cli ] ++ lib.optional cfg.skills.enable updater;

    systemd.user.services.ai-update-lark-cli-skills = lib.mkIf autoUpdate {
      Unit.Description = "Update official Lark CLI agent skills";
      Service = {
        Type = "oneshot";
        ExecStart = lib.getExe updater;
        TimeoutStartSec = "15min";
      };
    };

    systemd.user.timers.ai-update-lark-cli-skills = lib.mkIf autoUpdate {
      Unit.Description = "Update Lark CLI agent skills weekly";
      Timer = {
        OnCalendar = "weekly";
        Persistent = true;
      };
      Install.WantedBy = [ "timers.target" ];
    };
  };
}
