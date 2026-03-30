{ ... }:

{
  imports = [ ./sddm-themes/silent-sddm.nix ];

  services.displayManager = {
    sddm = {
      enable = true;
      wayland.enable = true;
      autoNumlock = true;
    };
  };

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  services.desktopManager.plasma6.enable = true;
}
