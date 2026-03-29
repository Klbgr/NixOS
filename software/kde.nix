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
}
