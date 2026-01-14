{ pkgs, ... }:

{
  home.packages = with pkgs; [
    (google-chrome.override {
      commandLineArgs = [
        "--enable-features=TouchpadOverscrollHistoryNavigation"
        "--ozone-platform-hint=auto"
      ];
    })
    vlc
    rquickshare
    spotify
    ookla-speedtest
    moonlight-qt
  ];

  programs = {
    discord = {
      enable = true;
    };
    # thunderbird = {
    #   enable = true;
    # };
  };
}
