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
    exec = "google-chrome-stable --app=https://gemini.google.com --class=chrome-gemini.google.com__-Default --name=chrome-gemini.google.com__-Default";
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

  thunderbirdIcon = builtins.readFile (
    pkgs.runCommand "resized-image-b64"
      {
        nativeBuildInputs = [ pkgs.imagemagick ];
        src = pkgs.fetchurl {
          url = "https://upload.wikimedia.org/wikipedia/commons/5/53/Thunderbird_2023_icon.png";
          hash = "sha256-02hTT2pxLbOBbTit+2Cv/xKDZXj+2mnOHoe2pKvDU8U=";
        };
      }
      ''
        magick $src -resize 256x256! png:- | base64 -w 0 > $out
      ''
  );
  thunderbirdUnreadIcon = builtins.readFile (
    pkgs.runCommand "resized-image-red-dot"
      {
        nativeBuildInputs = [ pkgs.imagemagick ];
        src = pkgs.fetchurl {
          url = "https://upload.wikimedia.org/wikipedia/commons/5/53/Thunderbird_2023_icon.png";
          hash = "sha256-02hTT2pxLbOBbTit+2Cv/xKDZXj+2mnOHoe2pKvDU8U=";
        };
      }
      ''
        magick $src -resize 256x256! \
          -fill red -draw "circle 192,64 224,64" \
          png:- | base64 -w 0 > $out
      ''
  );

  profile = "${config.home.homeDirectory}/.thunderbird/Default";
  msfFiles = builtins.filter (path: lib.hasSuffix ".msf" (toString path)) (
    lib.filesystem.listFilesRecursive profile
  );
  accounts = builtins.toJSON msfFiles;
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
    rquickshare
    ookla-speedtest
    moonlight-qt
    easyeffects
    gemini
    (birdtray.overrideAttrs (oldAttrs: {
      cmakeFlags = (oldAttrs.cmakeFlags or [ ]) ++ [
        "-DOPT_THUNDERBIRD_CMDLINE=${pkgs.thunderbird}/bin/thunderbird"
      ];
    }))
  ];

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
    (mkDesktopFile "RQuickShare" {
      Type = "Application";
      Name = "RQuickShare";
      Exec = "rquickshare";
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

    {
      "easyeffects/db/easyeffectsrc".text = lib.generators.toINI { } {
        Window = {
          showTrayIcon = false;
        };
      };
      "birdtray-config.json".text = ''
        {
          "accounts": ${accounts},
          "advanced/blinkingusealpha": false,
          "advanced/forcedRereadInterval": 0,
          "advanced/ignoreNetWMhints": false,
          "advanced/ignoreUpdateVersion": "",
          "advanced/notificationfontmaxsize": 512,
          "advanced/notificationfontminsize": 4,
          "advanced/onlyShowIconOnUnreadMessages": false,
          "advanced/runProcessOnChange": "",
          "advanced/tbprocessname": "thunderbird",
          "advanced/tbwindowmatch": " Thunderbird",
          "advanced/unreadopacitylevel": 0.75,
          "advanced/updateOnStartup": false,
          "advanced/watchfiletimeout": 150,
          "common/allowsuppressingunread": false,
          "common/blinkspeed": 0,
          "common/bordercolor": "#ffffff",
          "common/borderwidth": 0,
          "common/defaultcolor": "#0000ff",
          "common/exitthunderbirdonquit": true,
          "common/forceIgnoreUnreadEmailsOnMinimize": false,
          "common/hideWhenStartedManually": true,
          "common/hidewhenminimized": true,
          "common/hidewhenrestarted": true,
          "common/hidewhenstarted": true,
          "common/ignoreShowUnreadCount": false,
          "common/ignoreStartUnreadCount": false,
          "common/launchthunderbird": true,
          "common/launchthunderbirddelay": 0,
          "common/monitorthunderbirdwindow": true,
          "common/newemailEnabled": false,
          "common/notificationfont": "Noto Sans,10,-1,0,50,0,0,0,0,0",
          "common/notificationfontweight": 50,
          "common/notificationicon": "${thunderbirdIcon}",
          "common/notificationiconunread": "${thunderbirdUnreadIcon}",
          "common/restartthunderbird": true,
          "common/showDialogIfNoAccountsConfigured": false,
          "common/showhidethunderbird": true,
          "common/showunreademailcount": false,
          "common/startClosedThunderbird": true
        }
      '';
    }
  ];
}
