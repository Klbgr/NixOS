{ pkgs, ... }:

{
  boot.kernelPackages = pkgs.linuxPackages_cachyos-lto;
  hardware.nvidia.package = pkgs.nvidia_cachyos;
}
