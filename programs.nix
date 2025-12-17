{ config, pkgs, ... }:

{
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    google-chrome
    vlc
    solaar
    rquickshare
    discord
    spotify
    ookla-speedtest
    libva
  ];

  hardware.logitech.wireless.enable = true;
}
