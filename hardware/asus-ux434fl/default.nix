{ lib, config, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../modules/intel-cpu.nix
    ../modules/nvidia-gpu.nix
    ../modules/face-recognition.nix
    ../modules/asus.nix
    ../modules/touchpad.nix
  ];

  networking.hostName = "ASUS-UX434FL";

  boot.kernelParams = [
    "i915.enable_psr=0"
    "btusb.enable_autosuspend=0"
  ];

  hardware.nvidia = {
    open = lib.mkForce false;
    package = lib.mkForce config.boot.kernelPackages.nvidiaPackages.legacy_580;
    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
      intelBusId = "PCI:0@0:2:0";
      nvidiaBusId = "PCI:2@0:0:0";
    };
  };

  swapDevices = lib.mkForce [
    {
      device = "/var/lib/swapfile";
      size = 12 * 1024;
      priority = 0;
    }
  ];

  services.nohang.configPath = "basic";

  services.howdy.settings.video.device_path = "/dev/video2";
}
