{
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
  ];

  dconf.settings = {
    "io/github/nozwock/Packet" = {
      auto-start = false;
      device-visibility = true;
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

    {
      "easyeffects/db/easyeffectsrc".text = lib.generators.toINI { } {
        Window = {
          showTrayIcon = false;
        };
      };
    }
  ];
}
