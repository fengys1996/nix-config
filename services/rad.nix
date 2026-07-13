{ config, ... }:

{
  systemd.user.services.rad = {
    Unit = {
      Description = "rad (rust-analyzer daemon)";
      After = [ "default.target" ];
    };

    Service = {
      Type = "simple";
      WorkingDirectory = config.home.homeDirectory;
      Environment = [
        "RUST_LOG=info"
      ];
      ExecStart =
        "${config.home.homeDirectory}/.cargo/bin/rad server";
      Restart = "always";
      RestartSec = 2;
      NoNewPrivileges = true;
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
  };
}
