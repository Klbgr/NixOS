{ ... }:
let
  omv = "192.168.0.4";
  ha = "192.168.0.5";
  domain = "klbgr.com";

  localIps = [
    "127.0.0.1/32"
    "192.168.0.0/16"
    "::1/128"
    "fc00::/7"
    "fe80::/10"
    "2a01:e0a:a48:61d0::/64"
  ];

  localRanges = ''
    ${builtins.concatStringsSep "\n" (map (ip: "allow ${ip};") localIps)}
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
    appendHttpConfig = ''
      geo $dashy_backend {
        default        dashy-public;
        ${builtins.concatStringsSep "\n" (map (ip: "${ip}   dashy-local;") localIps)}
      }
    '';

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
          dashy-public = "127.0.0.1:8888";
          dashy-local = "127.0.0.1:8889";

          homeassistant = "${ha}:8123";
          jellyfin = "${omv}:8096";
          jellyseerr = "${omv}:5055";
          immich = "${omv}:2283";
          filebrowser = "${omv}:8000";
          affine = "${omv}:3010";
          sparkyfitness = "${omv}:3004";

          gatus = "127.0.0.1:8080";
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
        backendUrl = "http://$dashy_backend";
      };
      "dashy.${domain}" = makeHost {
        backendUrl = "http://$dashy_backend";
      };

      "homeassistant.${domain}" = makeHost {
        backendUrl = "http://homeassistant";
      };
      "jellyfin.${domain}" = makeHost {
        backendUrl = "http://jellyfin";
      };
      "jellyseerr.${domain}" = makeHost {
        backendUrl = "http://jellyseerr";
      };
      "immich.${domain}" = makeHost {
        backendUrl = "http://immich";
      };
      "filebrowser.${domain}" = makeHost {
        backendUrl = "http://filebrowser";
      };
      "affine.${domain}" = makeHost {
        backendUrl = "http://affine";
      };
      "sparkyfitness.${domain}" = makeHost {
        backendUrl = "http://sparkyfitness";
      };

      "gatus.${domain}" = makeHost {
        backendUrl = "http://gatus";
        localOnly = true;
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
