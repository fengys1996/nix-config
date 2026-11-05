{ config, ... }:

let
  home = config.home.homeDirectory;
  worker = "${home}/.cargo/bin/orbit-worker";
  configFile = "${config.xdg.configHome}/orbit/worker.toml";
  tokenFile = "${config.xdg.configHome}/orbit/worker.token";
in {
  xdg.configFile."orbit/worker.toml".source = ../dot/orbit/worker.toml;

  systemd.user.services.orbit-worker = {
    Unit = {
      Description = "ORBIT Worker (N100)";
      # Worker reconnects itself; do not order after the target that wants it.
      # Provision the binary and credential before starting the service.
      ConditionPathExists = [ worker tokenFile ];
    };
    Service = {
      Type = "simple";
      WorkingDirectory = home;
      Environment = [
        "RUST_LOG=info"
        "PATH=/run/wrappers/bin:${home}/.cargo/bin:${home}/.local/bin:${home}/.nix-profile/bin:/etc/profiles/per-user/${config.home.username}/bin:/run/current-system/sw/bin"
      ];
      ExecStartPre = "${worker} check-config --config ${configFile}";
      ExecStart = "${worker} serve --config ${configFile}";
      Restart = "on-failure";
      RestartSec = 5;
      TimeoutStopSec = 45;
      KillMode = "mixed";
      UMask = "0077";
      NoNewPrivileges = true;
    };
    Install.WantedBy = [ "default.target" ];
  };
}
