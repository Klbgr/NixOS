{ config, pkgs, ... }:

{
  imports = [ ./sddm-themes/silent-sddm.nix ];

  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    autoNumlock = true;
  };

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    QT_NO_XDG_DESKTOP_PORTAL = "1";
  };

  services.desktopManager.plasma6.enable = true;

  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    khelpcenter
    elisa
  ];

  services.xserver.excludePackages = with pkgs; [ xterm ];

  programs.kdeconnect.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.kdePackages.xdg-desktop-portal-kde
    ];
    config.common.default = "kde";
    config.kde.default = "kde";
  };
}
