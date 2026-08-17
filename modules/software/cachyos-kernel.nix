{ inputs, pkgs, ... }:

{
  imports = [ inputs.chaotic.nixosModules.default ];

  boot.kernelPackages = pkgs.linuxPackages_cachyos-lto;
  hardware.nvidia.package = pkgs.nvidia_cachyos;
}
