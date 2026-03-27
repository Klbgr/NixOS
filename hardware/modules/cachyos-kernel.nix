{ pkgs, ... }:
let
  nix-cachyos-kernel = builtins.getFlake "github:xddxdd/nix-cachyos-kernel/release";
in
{
  nixpkgs.overlays = [ nix-cachyos-kernel.overlays.default ];

  boot.kernelPackages =
    nix-cachyos-kernel.legacyPackages."${pkgs.system}".linuxPackages-cachyos-bore-lto;

  nix.settings = {
    substituters = [
      "https://attic.xuyh0120.win/lantian"
      "https://cache.garnix.io"
    ];
    trusted-public-keys = [
      "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="
      "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
    ];
  };
}
