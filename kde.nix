{ config, ... }:

{
  services.flatpak.enable = true;

  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    autoNumlock = true;
  };

  services.desktopManager.plasma6.enable = true;
}
