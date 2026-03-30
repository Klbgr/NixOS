{ ... }:

{
  imports = [ ./sddm-themes/silent-sddm.nix ];

  services.displayManager = {
    sddm = {
      enable = true;
      wayland.enable = true;
      autoNumlock = true;
      settings.Autologin.User = "antoine";
    };
  };

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  services.desktopManager.plasma6.enable = true;
}
