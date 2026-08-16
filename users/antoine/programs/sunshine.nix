{ inputs, pkgs, ... }:
let
  pegasusIcon = pkgs.fetchurl {
    url = "https://cdn2.steamgriddb.com/grid/90b8b243b361a90856ebe6543a502ccd.png";
    hash = "sha256-L4qC0uUHtWNYvplmCxV8JrVZG/RhZge6gEt82v1BgDY=";
  };

  connectCmd = pkgs.writeShellScript "sunshine-vd-connect" ''
    echo "--connect,--width,''${SUNSHINE_CLIENT_WIDTH},--height,''${SUNSHINE_CLIENT_HEIGHT},--refresh-rate,''${SUNSHINE_CLIENT_FPS}" \
      | ${pkgs.netcat-openbsd}/bin/nc -U /tmp/sunshineVD.sock
  '';

  disconnectCmd = pkgs.writeShellScript "sunshine-vd-disconnect" ''
    echo "--disconnect" | ${pkgs.netcat-openbsd}/bin/nc -U /tmp/sunshineVD.sock
  '';
in
{
  services.sunshine = {
    enable = true;
    package = pkgs.sunshine.override {
      cudaSupport = true;
    };
    settings = {
      locale = "fr";
      system_tray = "disabled";
      capture = "kms";
    };
    autoStart = true;
    capSysAdmin = true;
    openFirewall = true;
    applications = {
      apps = [
        {
          name = "Desktop";
          "image-path" = "desktop.png";
          "prep-cmd" = [
            {
              do = "${connectCmd}";
              undo = "${disconnectCmd}";
            }
          ];
        }
        {
          name = "Pegasus";
          detached = [
            "sudo -u antoine setsid pegasus-fe"
          ];
          "prep-cmd" = [
            {
              do = "${connectCmd}";
              undo = "${disconnectCmd}";
            }
            {
              do = "";
              undo = "setsid pkill -9 pegasus-fe";
            }
          ];
          "image-path" = pegasusIcon;
        }
      ];
    };
  };

  systemd.services.sunshineVD = {
    description = "Sunshine Virtual Display Daemon";
    after = [
      "display-manager.service"
      "dbus.service"
    ];
    requires = [ "dbus.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${inputs.nixkit.packages.${pkgs.system}.sunshine-virt-display}/bin/sunshineVD";
      Restart = "always";
      RestartSec = "3s";
      TimeoutStopSec = "10s";
      User = "root";
      Group = "root";
    };
  };
}
