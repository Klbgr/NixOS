{ ... }:
let
  prefix = "https://";
  suffix = ".klbgr.com/";

  dashy-settings =
    {
      local ? false,
    }:
    {
      pageInfo = {
        title = "Tableau de bord";
        description = "Services personnels";
        color = "#0d0d0d";
      };
      appConfig = {
        theme = "neomorphic";
        customColors = {
          neomorphic = {
            primary = "#fff";
            background = "#0d0d0d";
            background-darker = "#0d0d0d";
          };
        };
        customCss = ".options-outer, .edit-mode-item { display: none !important; }";
        startingView = "default";
        defaultOpeningMethod = "newtab";
        statusCheck = false;
        statusCheckInterval = 0;
        faviconApi = "allesedv";
        layout = "auto";
        iconSize = "large";
        routingMode = "history";
        enableMultiTasking = false;
        widgetsAlwaysUseProxy = false;
        webSearch = {
          disableWebSearch = true;
        };
        enableFontAwesome = true;
        enableMaterialDesignIcons = false;
        hideComponents = {
          hideHeading = true;
          hideNav = true;
          hideSearch = true;
          hideSettings = true;
          hideFooter = true;
        };
        auth = {
          enableGuestAccess = true;
          users = [ ];
          enableOidc = false;
          enableHeaderAuth = false;
          enableKeycloak = false;
        };
        showSplashScreen = false;
        preventWriteToDisk = true;
        preventLocalSave = true;
        disableConfiguration = true;
        disableConfigurationForNonAdmin = false;
        allowConfigEdit = false;
        enableServiceWorker = false;
        disableContextMenu = false;
        disableUpdateChecks = false;
        disableSmartSort = true;
        enableErrorReporting = false;
      };
      sections = [
        {
          name = "Publique";
          icon = "fas fa-globe";
          displayData = {
            sortBy = "default";
            rows = 2;
            cols = 2;
            collapsed = false;
            hideForGuests = false;
          };
          items = [
            {
              title = "Home Assistant";
              description = "Domotique";
              icon = "hl-home-assistant";
              url = prefix + "homeassistant" + suffix;
            }
            {
              title = "Jellyfin";
              description = "Films et séries";
              icon = "hl-jellyfin";
              url = prefix + "jellyfin" + suffix;
            }
            {
              title = "Seer";
              description = "Demandes de films et séries";
              icon = "hl-seerr";
              url = prefix + "jellyseerr" + suffix;
            }
            {
              title = "Immich";
              description = "Photos";
              icon = "hl-immich";
              url = prefix + "immich" + suffix;
            }
            {
              title = "File Browser";
              description = "Gestionnaire de fichiers";
              icon = "hl-filebrowser";
              url = prefix + "filebrowser" + suffix;
            }
            {
              title = "AFFiNE";
              description = "Notes";
              icon = "hl-affine";
              url = prefix + "affine" + suffix;
            }
          ];
        }
      ]
      ++ (
        if local then
          [
            {
              name = "Local";
              icon = "fas fa-network-wired";
              displayData = {
                sortBy = "default";
                rows = 2;
                cols = 2;
                collapsed = false;
                hideForGuests = false;
              };
              items = [
                {
                  title = "Gatus";
                  description = "Vérification de services";
                  icon = "hl-gatus";
                  url = prefix + "gatus" + suffix;
                }
                {
                  title = "Freebox";
                  description = "Gestion Freebox";
                  icon = "hl-freebox-pop";
                  url = prefix + "freebox" + suffix;
                }
                {
                  title = "Ender 3";
                  description = "Imprimante 3D";
                  icon = "hl-fluidd";
                  url = prefix + "ender3" + suffix;
                }
                {
                  title = "Proxmox";
                  description = "Machines virtuelles";
                  icon = "hl-proxmox";
                  url = prefix + "proxmox" + suffix;
                }
                {
                  title = "OpenMediaVault";
                  description = "NAS";
                  icon = "hl-openmediavault";
                  url = prefix + "openmediavault" + suffix;
                }
                {
                  title = "AdGuard Home";
                  description = "Bloqueur de publicités";
                  icon = "hl-adguardhome";
                  url = prefix + "adguardhome" + suffix;
                }
                {
                  title = "Frigate";
                  description = "Enregistrement caméras";
                  icon = "hl-frigate";
                  url = prefix + "frigate" + suffix;
                }
                {
                  title = "qBittorrent";
                  description = "Torrent";
                  icon = "hl-qbittorrent";
                  url = prefix + "qbittorrent" + suffix;
                }
                {
                  title = "Prowlarr";
                  description = "Indexeur de torrents";
                  icon = "hl-prowlarr";
                  url = prefix + "prowlarr" + suffix;
                }
                {
                  title = "Radarr";
                  description = "Gestion de films";
                  icon = "hl-radarr";
                  url = prefix + "radarr" + suffix;
                }
                {
                  title = "Sonarr";
                  description = "Gestion de séries";
                  icon = "hl-sonarr";
                  url = prefix + "sonarr" + suffix;
                }
                {
                  title = "Traccar";
                  description = "Suivi d'appareils";
                  icon = "hl-traccar";
                  url = prefix + "traccar" + suffix;
                }
              ];
            }
          ]
        else
          [ ]
      );
    };
in
{
  containers.dashy-public = {
    autoStart = true;
    forwardPorts = [
      {
        hostPort = 8888;
        containerPort = 8888;
      }
    ];
    config = { ... }: {
      networking.firewall.allowedTCPPorts = [ 8888 ];
      services.dashy = {
        enable = true;
        virtualHost = {
          enableNginx = true;
          domain = "localhost";
        };
        settings = dashy-settings { local = false; };
      };
      services.nginx = {
        enable = true;
        virtualHosts."localhost".listen = [
          {
            addr = "0.0.0.0";
            port = 8888;
          }
        ];
      };
      system.stateVersion = "25.11";
    };
  };

  containers.dashy-local = {
    autoStart = true;
    forwardPorts = [
      {
        hostPort = 8889;
        containerPort = 8889;
      }
    ];
    config = { ... }: {
      networking.firewall.allowedTCPPorts = [ 8889 ];
      services.dashy = {
        enable = true;
        virtualHost = {
          enableNginx = true;
          domain = "localhost";
        };
        settings = dashy-settings { local = true; };
      };
      services.nginx = {
        enable = true;
        virtualHosts."localhost".listen = [
          {
            addr = "0.0.0.0";
            port = 8889;
          }
        ];
      };
      system.stateVersion = "25.11";
    };
  };

  networking.firewall.allowedTCPPorts = [
    8888
    8889
  ];
}
