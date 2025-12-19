{ config, ... }:

{
  imports = [
    ./intel-igpu.nix
    ./nvidia-gpu.nix
    ./fan.nix
    ./led.nix
    ./gaming.nix
    ./developing.nix
    ./vm.nix
  ];

  networking.hostName = "Antoine";
  boot.kernelModules = [ "nct6687" ];
  boot.extraModulePackages = with config.boot.kernelPackages; [
    nct6687d
  ];
}
