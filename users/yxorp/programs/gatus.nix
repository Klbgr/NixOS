{ pkgs, lib, ... }:
let
  domain = "klbgr.com";

  makeEndpoint =
    { name, url }:
    ''
      - name: "${name}"
        url: "${url}"
        interval: "30s"
        conditions:
          - "[STATUS] == 200"
          - "[RESPONSE_TIME] < 1000"
        alerts:
          - type: "email"
            enabled: true
            success-threshold: 1
            failure-threshold: 3
            minimum-reminder-interval: 30m
            send-on-resolved: true'';
in
{
  services.gatus = {
    enable = true;
    environmentFile = "/var/lib/secrets/smtp";
    openFirewall = true;
    configFile = pkgs.writeText "gatus.yaml" ''
      web:
        port: 8080
      alerting:
        email:
          from: "''${SMTP_EMAIL}"
          username: "''${SMTP_USERNAME}"
          password: "''${SMTP_PASSWORD}"
          host: "''${SMTP_HOST}"
          port: 587
          to: "qiuantoine@gmail.com"
      storage:
        type: "sqlite"
        path: "/var/lib/gatus/db.sqlite"
      endpoints:
      ${lib.concatStringsSep "\n" [
        (makeEndpoint {
          name = "Dashy";
          url = "https://dashy.${domain}";
        })

        (makeEndpoint {
          name = "Home Assistant";
          url = "https://homeassistant.${domain}";
        })
        (makeEndpoint {
          name = "Jellyfin";
          url = "https://jellyfin.${domain}";
        })
        (makeEndpoint {
          name = "Seerr";
          url = "https://jellyseerr.${domain}";
        })
        (makeEndpoint {
          name = "Immich";
          url = "https://immich.${domain}";
        })
        (makeEndpoint {
          name = "File Browser";
          url = "https://filebrowser.${domain}";
        })
        (makeEndpoint {
          name = "AFFiNE";
          url = "https://affine.${domain}";
        })
        (makeEndpoint {
          name = "SparkyFitness";
          url = "https://sparkyfitness.${domain}";
        })

        (makeEndpoint {
          name = "Freebox";
          url = "https://freebox.${domain}";
        })
        (makeEndpoint {
          name = "Proxmox";
          url = "https://proxmox.${domain}";
        })
        (makeEndpoint {
          name = "openmediavault";
          url = "https://openmediavault.${domain}";
        })
        (makeEndpoint {
          name = "AdGuard Home";
          url = "http://adguardhome.${domain}";
        })
        (makeEndpoint {
          name = "Frigate";
          url = "http://frigate.${domain}";
        })
        (makeEndpoint {
          name = "qBittorrent";
          url = "http://qbittorrent.${domain}";
        })
        (makeEndpoint {
          name = "Prowlarr";
          url = "http://prowlarr.${domain}";
        })
        (makeEndpoint {
          name = "Radarr";
          url = "http://radarr.${domain}";
        })
        (makeEndpoint {
          name = "Sonarr";
          url = "http://sonarr.${domain}";
        })
        (makeEndpoint {
          name = "Traccar";
          url = "http://traccar.${domain}";
        })
      ]}
    '';
  };
}
