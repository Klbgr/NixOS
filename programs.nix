{ config, pkgs, ... }:

{
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    (google-chrome.override {
      commandLineArgs = [
        "--enable-features=TouchpadOverscrollHistoryNavigation"
      ];
    })
    vlc
    solaar
    rquickshare
    discord
    spotify
    ookla-speedtest
    moonlight-qt
  ];

  hardware.logitech.wireless.enable = true;
}
