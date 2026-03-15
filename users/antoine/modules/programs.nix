{ ... }:

{
  home-manager.users.antoine =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    let
      spicetify-nix = import (builtins.fetchTarball {
        url = "https://github.com/Gerg-L/spicetify-nix/archive/master.tar.gz";
      }) { };
      spicePkgs = spicetify-nix.packages;

      geminiIcon =
        let
          rawIcon = pkgs.fetchurl {
            url = "https://upload.wikimedia.org/wikipedia/commons/thumb/1/1d/Google_Gemini_icon_2025.svg/1280px-Google_Gemini_icon_2025.svg.png";
            sha256 = "sha256-ntHMZdVhvnx5I496JeTnPoU47vtPh1Wahr1tV/Hl00Y=";
          };
        in
        pkgs.runCommand "gemini.png"
          {
            nativeBuildInputs = [ pkgs.imagemagick ];
          }
          ''
            magick "${rawIcon}" -background none -gravity center -extent 125% $out
          '';

      gemini = pkgs.makeDesktopItem {
        name = "chrome-gemini.google.com__-Default";
        desktopName = "Gemini";
        genericName = "Google Gemini";
        exec = "google-chrome-stable --user-data-dir=${config.home.homeDirectory}/.config/gemini --app=https://gemini.google.com --class=chrome-gemini.google.com__-Default --name=chrome-gemini.google.com__-Default";
        terminal = false;
        categories = [ "Network" ];
        type = "Application";
        icon = "${geminiIcon}";
        startupWMClass = "chrome-gemini.google.com__-Default";
      };

      mkDesktopFile = name: settings: {
        "autostart/${name}.desktop".text = lib.generators.toINI { } {
          "Desktop Entry" = settings;
        };
      };
    in
    {
      imports = [
        spicetify-nix.homeManagerModules.spicetify
      ];

      home.packages = with pkgs; [
        (google-chrome.override {
          commandLineArgs = [
            "--enable-features=TouchpadOverscrollHistoryNavigation"
            "--ozone-platform-hint=auto"
          ];
        })
        vlc
        ookla-speedtest
        moonlight-qt
        easyeffects
        gemini
        telegram-desktop
        packet
        freecad
        orca-slicer
        affine
        qdiskinfo
        kdiskmark
        gimp
      ];

      dconf.settings = {
        "io/github/nozwock/Packet" = {
          auto-start = false;
          device-visibility = true;
          download-folder = "${config.home.homeDirectory}/Downloads";
          enable-nautilus-plugin = false;
          enable-static-port = true;
          run-in-background = true;
          static-port-number = 9300;
        };
      };

      programs = {
        vesktop = {
          enable = true;
          settings = {
            discordBranch = "stable";
            minimizeToTray = true;
            arRPC = true;
            hardwareAcceleration = true;
            customTitleBar = true;
            enableMenu = false;
            clickTrayToShowHide = true;
            enableTaskbarFlashing = false;
            autoStartMinimized = false;
            hardwareVideoAcceleration = false;
            staticTitle = false;
            enableSplashScreen = true;
            splashTheming = false;
            tray = true;
            disableMinSize = false;
            disableSmoothScroll = false;
            appBadge = true;
            openLinksWithElectron = false;
          };
          vencord = {
            settings = {
              autoUpdate = true;
              autoUpdateNotification = true;
              useQuickCss = false;
              themeLinks = [
                "https://capnkitten.github.io/BetterDiscord/Themes/Material-Discord/css/source.css"
              ];
              eagerPatches = false;
              enabledThemes = [ ];
              enableReactDevtools = false;
              frameless = false;
              transparent = true;
              winCtrlQ = false;
              disableMinSize = false;
              winNativeTitleBar = false;
            };
          };
        };
        spicetify = {
          enable = true;
          theme = spicePkgs.themes.defaultDynamic;
          colorScheme = "Dark-Base";
          enabledCustomApps = [
            spicePkgs.apps.ncsVisualizer
          ];
        };
        onlyoffice = {
          enable = true;
        };
      };

      xdg.configFile = lib.mkMerge [
        (mkDesktopFile "Vesktop" {
          Type = "Application";
          Name = "Vesktop";
          Exec = "vesktop -m";
        })
        (mkDesktopFile "Spotify" {
          Type = "Application";
          Name = "Spotify";
          Exec = "spotify --minimized";
        })
        (mkDesktopFile "EasyEffects" {
          Type = "Application";
          Name = "Easy Effects";
          Exec = "easyeffects --hide-window";
        })
        (mkDesktopFile "Birdtray" {
          Type = "Application";
          Name = "Birdtray";
          Exec = "env GDK_BACKEND=x11 birdtray";
        })
        (mkDesktopFile "Telegram" {
          Type = "Application";
          Name = "Telegram";
          Exec = "Telegram -startintray";
        })
        (mkDesktopFile "Packet" {
          Type = "Application";
          Name = "Packet";
          Exec = "packet -b";
        })
        (mkDesktopFile "AFFiNE" {
          Type = "Application";
          Name = "AFFiNE";
          Exec = "affine";
        })

        {
          "easyeffects/db/easyeffectsrc".text = lib.generators.toINI { } {
            StreamOutputs = {
              plugins = "bass_enhancer#0,crystalizer#0";
              visiblePage = "pluginsPage";
            };
            Window = {
              showTrayIcon = false;
            };
          };
          "ookla/speedtest-cli.json".text = ''
            {
                "Settings": {
                    "LicenseAccepted": "604ec27f828456331ebf441826292c49276bd3c1bee1a2f65a6452f505c4061c",
                    "GDPRTimeStamp": 1773584199
                }
            }
          '';
        }
      ];

      home.activation.mergeAffineConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        merge_json() {
          local DEST_FILE="$1"
          local WANTED_JSON="$2"
          local DIR
          DIR=$(dirname "$DEST_FILE")

          if [ ! -d "$DIR" ]; then
            mkdir -p "$DIR"
          fi

          if [ -f "$DEST_FILE" ]; then
            local TEMP_FILE
            TEMP_FILE=$(mktemp)
            ${pkgs.jq}/bin/jq -s '.[0] * .[1]' "$DEST_FILE" <(echo "$WANTED_JSON") > "$TEMP_FILE"
            mv "$TEMP_FILE" "$DEST_FILE"
          else
            echo "$WANTED_JSON" > "$DEST_FILE"
          fi
        }

        STATE_FILE="$HOME/.config/AFFiNE/global-state.json"
        CACHE_FILE="$HOME/.config/AFFiNE/global-cache.json"

        WANTED_STATE='{
          "menubarState": {
            "closeToTray": true,
            "enabled": true,
            "minimizeToTray": true,
            "openOnLeftClick": true,
            "startMinimized": true
          },
          "spellCheckState": {
            "enabled": true
          },
          "editor-setting": {
            "edgelessDefaultTheme": "\"auto\"",
            "edgelessScrollZoom": "true",
            "newDocDefaultMode": "\"page\"",
            "fullWidthLayout": "false",
            "displayDocInfo": "true",
            "displayBiDirectionalLink": "true"
          }
        }'

        WANTED_CACHE='{
          "i18n_lng": "fr"
        }'

        merge_json "$STATE_FILE" "$WANTED_STATE"
        merge_json "$CACHE_FILE" "$WANTED_CACHE"
      '';
    };
}
