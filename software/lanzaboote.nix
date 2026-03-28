{ pkgs, lib, ... }:
let
  lanzabooteSrc = fetchTarball {
    url = "https://github.com/nix-community/lanzaboote/archive/v1.0.0.tar.gz";
  };
  lanzaboote = import lanzabooteSrc { inherit pkgs; };
in
{
  imports = [
    lanzaboote.nixosModules.lanzaboote
  ];

  environment.systemPackages = [
    pkgs.sbctl
  ];

  boot.loader.systemd-boot.enable = lib.mkForce false;

  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/var/lib/sbctl";
    autoGenerateKeys.enable = true;
  };
}
