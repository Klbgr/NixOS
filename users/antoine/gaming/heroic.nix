{ inputs, pkgs, ... }:
let
  rpcs3-nixpkgs = import inputs.rpcs3-nixpkgs {
    inherit (pkgs) system;
  };

  emulators = [
    {
      id = "ryujinx";
      title = "Ryujinx";
      exe = "${pkgs.ryubing}/bin/ryujinx";
      art = "8b74109a090f26752e80c9575b7c5508";
    }
    {
      id = "rpcs3";
      title = "RPCS3";
      exe = "${rpcs3-nixpkgs.rpcs3}/bin/rpcs3";
      art = "ace27c5277ecc8da47cd53ff5c82cb4f";
    }
    {
      id = "dolphin";
      title = "Dolphin";
      exe = "${pkgs.dolphin-emu}/bin/dolphin-emu";
      art = "0bbb77fa3a8420150c5cf70c3aff3fa9";
    }
    {
      id = "melonds";
      title = "melonDS";
      exe = "${pkgs.melonds}/bin/melonDS";
      art = "f1f0d32c08e78326f3a8b8ac5e7469a8";
    }
  ];
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

        $PATCHER json-heroic "$HEROIC_DIR/sideload_apps/library.json" '${
          builtins.toJSON {
            games = map (emu: {
              runner = "sideload";
              app_name = emu.id;
              title = emu.title;
              install = {
                executable = emu.exe;
                platform = "linux";
                is_dlc = false;
              };
              folder_name = ".";
              art_cover = "https://cdn2.steamgriddb.com/file/sgdb-cdn/grid/${emu.art}.png";
              is_installed = true;
              art_square = "https://cdn2.steamgriddb.com/file/sgdb-cdn/grid/${emu.art}.png";
              canRunOffline = true;
              browserUrl = "";
              customUserAgent = "";
              launchFullScreen = false;
            }) emulators;
          }
        }'

        ${lib.strings.concatStringsSep "\n" (
          map (emu: ''
            $PATCHER json "$HEROIC_DIR/GamesConfig/${emu.id}.json" '${
              builtins.toJSON {
                ${emu.id} = {
                  showMangohud = false;
                  useGameMode = false;
                  useSteamRuntime = false;
                };
              }
            }'
          '') emulators
        )}
      '';
    };
}
