{
  inputs,
  config,
  lib,
  ...
}:

{
  imports = with inputs.nixos-raspberrypi.nixosModules; [
    raspberry-pi-5.base
    raspberry-pi-5.page-size-16k
    raspberry-pi-5.display-vc4
    raspberry-pi-5.bluetooth
    ./hardware-configuration.nix
    ../server.nix
    ../../users/yxorp
  ];

  boot.loader.raspberry-pi.bootloader = "kernel";

  networking.hostName = "YXORP";

  system.nixos.tags =
    let
      cfg = config.boot.loader.raspberry-pi;
    in
    [
      "raspberry-pi-${cfg.variant}"
      cfg.bootloader
      config.boot.kernelPackages.kernel.version
    ];

  swapDevices = lib.mkForce [
    {
      device = "/var/lib/swapfile";
      size = 12 * 1024;
      priority = 0;
    }
  ];
}
