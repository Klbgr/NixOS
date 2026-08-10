{ ... }:
let
  omv = "192.168.0.4";
  ha = "192.168.0.5";
  domain = "klbgr.com";

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
      useACMEHost = domain;
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
    certs.${domain} = {
      domain = "*.${domain}";
      extraDomainNames = [ domain ];
      dnsProvider = "cloudflare";
      dnsPropagationCheck = true;
      environmentFile = "/var/lib/secrets/cloudflare-credentials";
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
        useACMEHost = domain;
        forceSSL = true;
        locations."/" = {
          extraConfig = "return 444;";
        };
      };

      ${domain} = makeHost {
        backendUrl = "http://homarr";
      };
      "affine.${domain}" = makeHost {
        backendUrl = "http://affine";
      };
      "filebrowser.${domain}" = makeHost {
        backendUrl = "http://filebrowser";
      };
      "homarr.${domain}" = makeHost {
        backendUrl = "http://homarr";
      };
      "homeassistant.${domain}" = makeHost {
        backendUrl = "http://homeassistant";
      };
      "immich.${domain}" = makeHost {
        backendUrl = "http://immich";
      };
      "jellyfin.${domain}" = makeHost {
        backendUrl = "http://jellyfin";
      };
      "jellyseerr.${domain}" = makeHost {
        backendUrl = "http://jellyseerr";
      };

      "freebox.${domain}" = makeHost {
        backendUrl = "https://freebox";
        localOnly = true;
      };
      "ender3.${domain}" = makeHost {
        backendUrl = "http://ender3";
        localOnly = true;
      };
      "proxmox.${domain}" = makeHost {
        backendUrl = "https://proxmox";
        localOnly = true;
      };
      "openmediavault.${domain}" = makeHost {
        backendUrl = "http://openmediavault";
        localOnly = true;
      };
      "adguardhome.${domain}" = makeHost {
        backendUrl = "http://adguardhome";
        localOnly = true;
      };
      "frigate.${domain}" = makeHost {
        backendUrl = "http://frigate";
        localOnly = true;
      };
      "qbittorrent.${domain}" = makeHost {
        backendUrl = "http://qbittorrent";
        localOnly = true;
      };
      "prowlarr.${domain}" = makeHost {
        backendUrl = "http://prowlarr";
        localOnly = true;
      };
      "radarr.${domain}" = makeHost {
        backendUrl = "http://radarr";
        localOnly = true;
      };
      "sonarr.${domain}" = makeHost {
        backendUrl = "http://sonarr";
        localOnly = true;
      };
      "traccar.${domain}" = makeHost {
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
