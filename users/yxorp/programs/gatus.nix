{ ... }:
let
  domain = "klbgr.com";

  makeEndpoint =
    {
      name,
      url,
    }:
    {
      name = name;
      url = url;
      interval = "30s";
      conditions = [
        "[STATUS] == 200"
        "[RESPONSE_TIME] < 1000"
      ];
    };
in
{
  services.gatus = {
    enable = true;
    openFirewall = true;
    settings = {
      web.port = 8080;
      storage = {
        type = "sqlite";
        path = "/var/lib/gatus/db.sqlite";
      };
      endpoints = [
        (makeEndpoint {
          name = "AFFiNE";
          url = "https://affine.${domain}";
        })
        (makeEndpoint {
          name = "File Browser";
          url = "https://filebrowser.${domain}";
        })
        (makeEndpoint {
          name = "Homarr";
          url = "https://homarr.${domain}";
        })
        (makeEndpoint {
          name = "Immich";
          url = "https://immich.${domain}";
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
      ];
    };
  };
}
