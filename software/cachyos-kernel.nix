{ pkgs, ... }:
let
  nix-cachyos-kernel = builtins.getFlake "github:xddxdd/nix-cachyos-kernel/release";
in
{
  nixpkgs.overlays = [ nix-cachyos-kernel.overlays.default ];

  boot.kernelPackages =
    nix-cachyos-kernel.legacyPackages."${pkgs.system}".linuxPackages-cachyos-latest-lto-x86_64-v3;

  nix.settings = {
    substituters = [
      "https://attic.xuyh0120.win/lantian"
    ];
    trusted-public-keys = [
      "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="
    ];
  };
}
