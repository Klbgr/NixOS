{ inputs, pkgs, ... }:
let
  rpcs3-nixpkgs = import inputs.rpcs3-nixpkgs {
    inherit (pkgs) system;
  };
in
{
  home-manager.users.antoine =
    { lib, pkgs, ... }:

    {
      home.packages = with pkgs; [
        heroic
      ];

      home.activation.mergeHeroicConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        PATCHER="${pkgs.configuration-patcher}/bin/configuration-patcher"

        CONFIG_FILE="$HOME/.config/heroic/config.json"
        SIDELOAD_FILE="$HOME/.config/heroic/sideload_apps/library.json"

        $PATCHER json "$CONFIG_FILE" '{
          "defaultSettings": {
            "checkForUpdatesOnStartup": false,
            "autoUpdateGames": false,
            "enableUpdates": false,
            "hideChangelogsOnStartup": true,
            "noTrayIcon": false,
            "exitToTray": true,
            "startInTray": false,
            "minimizeOnLaunch": false,
            "darkTrayIcon": false,
            "framelessWindow": false,
            "addDesktopShortcuts": false,
            "addStartMenuShortcuts": false,
            "addSteamShortcuts": true,
            "discordRPC": true,
            "downloadProtonToSteam": false,
            "analyticsOptIn": false,
            "libraryTopSection": "disabled",
            "maxWorkers": 0,
            "autoInstallDxvkNvapi": true,
            "enableEsync": true,
            "enableFsync": true,
            "enableWineWayland": false,
            "enableWoW64": false,
            "showFps": false,
            "showMangohud": true,
            "useGameMode": true,
            "useSteamRuntime": true,
            "battlEyeRuntime": true,
            "eacRuntime": true,
            "language": "fr",
            "showValveProton": false,
            "experimentalFeatures": {
                "enableHelp": false,
                "cometSupport": false,
                "zoomPlatform": false
            }
          }
        }'

        $PATCHER json-heroic "$SIDELOAD_FILE" '{
          "games": [
            {
              "runner": "sideload",
              "app_name": "ryujinx",
              "title": "Ryujinx",
              "install": {
                "executable": "${pkgs.ryubing}/bin/ryujinx",
                "platform": "linux",
                "is_dlc": false
              },
              "folder_name": ".",
              "art_cover": "https://cdn2.steamgriddb.com/file/sgdb-cdn/grid/8b74109a090f26752e80c9575b7c5508.png",
              "is_installed": true,
              "art_square": "https://cdn2.steamgriddb.com/file/sgdb-cdn/grid/8b74109a090f26752e80c9575b7c5508.png",
              "canRunOffline": true,
              "browserUrl": "",
              "customUserAgent": "",
              "launchFullScreen": false
            },
            {
              "runner": "sideload",
              "app_name": "rpcs3",
              "title": "RPCS3",
              "install": {
                "executable": "${rpcs3-nixpkgs.rpcs3}/bin/rpcs3",
                "platform": "linux",
                "is_dlc": false
              },
              "folder_name": ".",
              "art_cover": "https://cdn2.steamgriddb.com/file/sgdb-cdn/grid/ace27c5277ecc8da47cd53ff5c82cb4f.png",
              "is_installed": true,
              "art_square": "https://cdn2.steamgriddb.com/file/sgdb-cdn/grid/ace27c5277ecc8da47cd53ff5c82cb4f.png",
              "canRunOffline": true,
              "browserUrl": "",
              "customUserAgent": "",
              "launchFullScreen": false
            },
            {
              "runner": "sideload",
              "app_name": "dolphin",
              "title": "Dolphin",
              "install": {
                "executable": "${pkgs.dolphin-emu}/bin/dolphin-emu",
                "platform": "linux",
                "is_dlc": false
              },
              "folder_name": ".",
              "art_cover": "https://cdn2.steamgriddb.com/file/sgdb-cdn/grid/0bbb77fa3a8420150c5cf70c3aff3fa9.png",
              "is_installed": true,
              "art_square": "https://cdn2.steamgriddb.com/file/sgdb-cdn/grid/0bbb77fa3a8420150c5cf70c3aff3fa9.png",
              "canRunOffline": true,
              "browserUrl": "",
              "customUserAgent": "",
              "launchFullScreen": false
            },
            {
              "runner": "sideload",
              "app_name": "melonds",
              "title": "melonDS",
              "install": {
                "executable": "${pkgs.melonds}/bin/melonDS",
                "platform": "linux",
                "is_dlc": false
              },
              "folder_name": ".",
              "art_cover": "https://cdn2.steamgriddb.com/file/sgdb-cdn/grid/f1f0d32c08e78326f3a8b8ac5e7469a8.png",
              "is_installed": true,
              "art_square": "https://cdn2.steamgriddb.com/file/sgdb-cdn/grid/f1f0d32c08e78326f3a8b8ac5e7469a8.png",
              "canRunOffline": true,
              "browserUrl": "",
              "customUserAgent": "",
              "launchFullScreen": false
            }          
          ]
        }'
      '';

      home.file =
        let
          games = [
            "ryujinx"
            "rpcs3"
            "dolphin"
            "melonds"
          ];
          mkConfig = name: {
            text = builtins.toJSON {
              "${name}" = {
                showMangohud = false;
                useGameMode = false;
                useSteamRuntime = false;
              };
            };
          };
        in
        builtins.listToAttrs (
          map (name: {
            name = ".config/heroic/GamesConfig/${name}.json";
            value = mkConfig name;
          }) games
        );
    };
}
