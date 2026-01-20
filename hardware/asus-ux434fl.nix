{ config, pkgs, ... }:

{
  imports = [
    ./modules/intel-igpu.nix
    ./modules/nvidia-gpu-prime.nix
    ./modules/touchpad.nix
    ./modules/logitech.nix
  ];

  networking.hostName = "ZenBook";

  boot.extraModprobeConfig = ''
    options asus_wmi fnlock_default=0
  '';

  hardware.nvidia.prime = {
    intelBusId = "PCI:0@0:2:0";
    nvidiaBusId = "PCI:2@0:0:0";
  };
}
