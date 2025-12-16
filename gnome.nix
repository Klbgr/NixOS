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

  services.desktopManager.gnome = {
    enable = true;
    extraGSettingsOverridePackages = with pkgs; [ mutter ];
    extraGSettingsOverrides = ''
      [org.gnome.mutter]
      experimental-features=['variable-refresh-rate', 'scale-monitor-framebuffer']
      [org.gnome.shell]
      disable-extension-version-validation=true
    '';
  };

  environment.gnome.excludePackages = with pkgs; [
    epiphany
    totem
    gnome-music
    yelp
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
  ];
}
