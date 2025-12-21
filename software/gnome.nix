{
  config,
  pkgs,
  ...
}:

{
  services.displayManager.gdm = {
    enable = true;
    wayland = true;
  };

  services.desktopManager.gnome.enable = true;

  environment.gnome.excludePackages = with pkgs; [
    epiphany
    totem
    yelp
    showtime
    decibels
    seahorse
    geary
    gnome-music
    gnome-weather
    gnome-maps
    gnome-font-viewer
    gnome-characters
    gnome-logs
    gnome-tour
  ];

  environment.systemPackages = with pkgs.gnomeExtensions; [
    pkgs.ddcutil
    pkgs.gnome-tweaks
    dash-to-panel
    arcmenu
    appindicator
    gsconnect
    brightness-control-using-ddcutil
    burn-my-windows
    tiling-assistant
    clipboard-indicator
    arcmenu
    quick-settings-tweaker
    rounded-window-corners-reborn
    caffeine
    compiz-windows-effect
    emoji-copy
    search-light
    simpleweather
  ];
}
