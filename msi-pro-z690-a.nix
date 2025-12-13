{ config, ... }:

{
  imports = [
    ./gpu.nix
    ./fan.nix
    ./led.nix
    ./gaming.nix
    ./developing.nix
  ];

  networking.hostName = "Antoine";
  boot.kernelModules = [ "nct6687" ];
  boot.extraModulePackages = with config.boot.kernelPackages; [
    nct6687d
  ];
}
