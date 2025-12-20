{ config, ... }:

{
  imports = [
    ./hardware/intel-igpu.nix
    ./hardware/nvidia-gpu.nix
    ./hardware/fan.nix
    ./hardware/led.nix
    ./software/gnome.nix
    ./software/programs.nix
    ./software/developing.nix
    ./software/gaming.nix
    ./software/vm.nix
  ];

  networking.hostName = "Antoine";
  boot.kernelModules = [ "nct6687" ];
  boot.extraModulePackages = with config.boot.kernelPackages; [
    nct6687d
  ];
}
