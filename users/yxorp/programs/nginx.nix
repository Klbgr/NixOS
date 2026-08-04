{ ... }:
let
  omv = "192.168.0.4";
  ha = "192.168.0.5";
  url = "klbgr.com";

  localRanges = ''
    allow 127.0.0.1/32;
    allow 192.168.0.0/16;
    allow ::1/128;
    allow fc00::/7;
    allow fe80::/10;
    allow 2a01:e0a:a48:61d0::/64; 
    deny all;
    error_page 403 = 444;
  '';

  makeHost =
    {
      backendUrl,
      localOnly ? false,
    }:
    {
      useACMEHost = url;
      forceSSL = true;
      locations."/" = {
        proxyPass = backendUrl;
        proxyWebsockets = true;
        extraConfig = if localOnly then localRanges else "";
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
      credentialsFile = "/var/lib/secrets/cloudflare-credentials";
      group = "nginx";
    };
  };

  services.nginx = {
    enable = true;

    recommendedProxySettings = true;
    recommendedOptimisation = true;
    recommendedTlsSettings = true;
    clientMaxBodySize = "0";

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
          adguardhome = "127.0.0.1:3000";
          frigate = "${omv}:8971";
          qbittorrent = "${omv}:8080";
          prowlarr = "${omv}:9696";
          radarr = "${omv}:7878";
          sonarr = "${omv}:8989";
          traccar = "${omv}:8082";
        };

    virtualHosts = {
      "_" = {
        default = true;
        useACMEHost = url;
        forceSSL = true;
        locations."/" = {
          extraConfig = "return 444;";
        };
      };

      ${url} = makeHost {
        backendUrl = "http://homarr";
      };
      "affine.${url}" = makeHost {
        backendUrl = "http://affine";
      };
      "filebrowser.${url}" = makeHost {
        backendUrl = "http://filebrowser";
      };
      "homarr.${url}" = makeHost {
        backendUrl = "http://homarr";
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

  networking.nat = {
    enable = true;
    externalInterface = "end0";
    internalInterfaces = [ "end0" ];
    forwardPorts = [
      {
        sourcePort = 5093;
        destination = "${omv}:5093";
        proto = "tcp";
      }
      {
        sourcePort = 5093;
        destination = "${omv}:5093";
        proto = "udp";
      }
    ];
  };

  networking.firewall = {
    allowedTCPPorts = [
      80
      443
      5093
    ];
    allowedUDPPorts = [ 5093 ];
  };
}
