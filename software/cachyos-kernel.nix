{ inputs, pkgs, ... }:

{
  nixpkgs.overlays = [ inputs.nix-cachyos-kernel.overlays.default ];

  boot.kernelPackages =
    inputs.nix-cachyos-kernel.legacyPackages.${pkgs.stdenv.hostPlatform.system}.linuxPackages-cachyos-latest-lto-x86_64-v3;

  nix.settings = {
    substituters = [
      "https://attic.xuyh0120.win/lantian"
    ];
    trusted-public-keys = [
      "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="
    ];
  };
}
