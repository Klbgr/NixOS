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

        CONFIG_FILE="$HOME/.config/heroic/config.json"

        $PATCHER json "$CONFIG_FILE" '{
          "defaultSettings": {
            "language": "fr",
            "checkForUpdatesOnStartup": false,
            "autoUpdateGames": false,
            "enableUpdates": false,
            "hideChangelogsOnStartup": true,
            "noTrayIcon": false,
            "exitToTray": true,
            "startInTray": false,
            "minimizeOnLaunch": true,
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
