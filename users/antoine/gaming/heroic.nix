{ ... }:

{
  home-manager.users.antoine =
    { lib, pkgs, ... }:

    {
      home.packages = with pkgs; [
        heroic
      ];

      home.activation.mergeHeroicConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        PATCHER="${pkgs.configuration-patcher}/bin/configuration-patcher"

        HEROIC_DIR="$HOME/.config/heroic"

        $PATCHER json "$HEROIC_DIR/config.json" '{
          "defaultSettings": {
            "defaultInstallPath": "/games/Heroic",
            "defaultWinePrefix": "/games/Heroic/Prefixes/default",
            "defaultWinePrefixDir": "/games/Heroic/Prefixes/default",
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
            "winePrefix": "/games/Heroic/Prefixes/default",
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
      '';
    };
}
