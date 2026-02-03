{ pkgs, ... }:
let
  spicetify-nix = import (builtins.fetchTarball {
    url = "https://github.com/Gerg-L/spicetify-nix/archive/master.tar.gz";
  }) { };
  spicePkgs = spicetify-nix.packages;
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
}
