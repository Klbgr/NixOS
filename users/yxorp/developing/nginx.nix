{ ... }:
let
  omv = "192.168.0.4";
  ha = "192.168.0.5";
  url = "klbgr.com";

  makeHost =
    {
      backendUrl,
      default ? false,
      localOnly ? false,
    }:
    {
      useACMEHost = url;
      forceSSL = true;
      default = default;
      locations."/" = {
        proxyPass = backendUrl;
        proxyWebsockets = true;
        extraConfig =
          if localOnly then
            ''
              if ($is_local = 0) {
                return 444;
              }
            ''
          else
            "";
      };
    };
in
{
  security.acme = {
    acceptTerms = true;
    defaults.email = "qiuantoine@gmail.com";
    certs.${url} = {
      domain = "*.${url}";
      extraDomainNames = [ url ];
      dnsProvider = "cloudflare";
      dnsPropagationCheck = true;
      credentialsFile = "/var/lib/acme/cloudflare-credentials";
      group = "nginx";
    };
  };

  services.nginx = {
    enable = true;

    recommendedProxySettings = true;
    recommendedOptimisation = true;
    recommendedTlsSettings = true;
    clientMaxBodySize = "0";

    commonHttpConfig = ''
      geo $is_local {
        default 0;
        127.0.0.1/32 1;
        192.168.0.0/16 1;
      }
    '';

    upstreams =
      builtins.mapAttrs
        (_: serverAddr: {
          extraConfig = "server ${serverAddr}; keepalive 32;";
        })
        {
          affine = "${omv}:3010";
          filebrowser = "${omv}:8000";
          homarr = "${omv}:7575";
          homeassistant = "${ha}:8123";
          immich = "${omv}:2283";
          jellyfin = "${omv}:8096";
          jellyseerr = "${omv}:5055";

          freebox = "mafreebox.freebox.fr:443";
          ender3 = "192.168.0.3:80";
          proxmox = "192.168.0.6:8006";
          openmediavault = "${omv}:9999";
          adguardhome = "${omv}:3003";
          frigate = "${omv}:8971";
          qbittorrent = "${omv}:8080";
          prowlarr = "${omv}:9696";
          radarr = "${omv}:7878";
          sonarr = "${omv}:8989";
          traccar = "${omv}:8082";
        };

    virtualHosts = {
      "affine.${url}" = makeHost {
        backendUrl = "http://affine";
      };
      "filebrowser.${url}" = makeHost {
        backendUrl = "http://filebrowser";
      };
      "homarr.${url}" = makeHost {
        backendUrl = "http://homarr";
        default = true;
      };
      "homeassistant.${url}" = makeHost {
        backendUrl = "http://homeassistant";
      };
      "immich.${url}" = makeHost {
        backendUrl = "http://immich";
      };
      "jellyfin.${url}" = makeHost {
        backendUrl = "http://jellyfin";
      };
      "jellyseerr.${url}" = makeHost {
        backendUrl = "http://jellyseerr";
      };

      "freebox.${url}" = makeHost {
        backendUrl = "https://freebox";
        localOnly = true;
      };
      "ender3.${url}" = makeHost {
        backendUrl = "http://ender3";
        localOnly = true;
      };
      "proxmox.${url}" = makeHost {
        backendUrl = "https://proxmox";
        localOnly = true;
      };
      "openmediavault.${url}" = makeHost {
        backendUrl = "http://openmediavault";
        localOnly = true;
      };
      "adguardhome.${url}" = makeHost {
        backendUrl = "http://adguardhome";
        localOnly = true;
      };
      "frigate.${url}" = makeHost {
        backendUrl = "http://frigate";
        localOnly = true;
      };
      "qbittorrent.${url}" = makeHost {
        backendUrl = "http://qbittorrent";
        localOnly = true;
      };
      "prowlarr.${url}" = makeHost {
        backendUrl = "http://prowlarr";
        localOnly = true;
      };
      "radarr.${url}" = makeHost {
        backendUrl = "http://radarr";
        localOnly = true;
      };
      "sonarr.${url}" = makeHost {
        backendUrl = "http://sonarr";
        localOnly = true;
      };
      "traccar.${url}" = makeHost {
        backendUrl = "http://traccar";
        localOnly = true;
      };
    };
  };

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];
}
