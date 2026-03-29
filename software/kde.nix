{ pkgs, ... }:

{
  imports = [ ./sddm-themes/silent-sddm.nix ];

  services.displayManager = {
    sddm = {
      enable = true;
      wayland.enable = true;
      autoNumlock = true;
    };
    autoLogin = {
      enable = true;
      user = "antoine";
    };
  };

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  services.desktopManager.plasma6.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.kdePackages.xdg-desktop-portal-kde
    ];
    config.common.default = "kde";
    config.kde.default = "kde";
  };
}
