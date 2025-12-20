{ config, ... }:

{
  imports = [
    ./modules/nix-flatpak.nix
  ];

  services.flatpak.packages = [
    "io.github.vikdevelop.SaveDesktop"
  ];

  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    autoNumlock = true;
  };

  services.desktopManager.plasma6.enable = true;
}
