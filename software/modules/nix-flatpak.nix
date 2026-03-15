{ ... }:
let
  pkgs = import <nixpkgs> { };
  nix-flatpak = pkgs.fetchFromGitHub {
    owner = "gmodena";
    repo = "nix-flatpak";
    rev = "v0.6.0";
    hash = "sha256-iAVVHi7X3kWORftY+LVbRiStRnQEob2TULWyjMS6dWg=";
  };
in
{
  imports = [
    "${nix-flatpak}/modules/nixos.nix"
  ];

  services.flatpak.enable = true;
}
