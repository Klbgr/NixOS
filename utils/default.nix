{ lib, pkgs, ... }:
let
  dir = ./.;
  allFiles = builtins.readDir dir;
  nixFiles = builtins.filter (
    name: allFiles.${name} == "regular" && lib.hasSuffix ".nix" name && name != "default.nix"
  ) (builtins.attrNames allFiles);
  packageMap = lib.genAttrs (map (lib.removeSuffix ".nix") nixFiles) (name: dir + "/${name}.nix");
in
{
  nixpkgs.overlays = [
    (final: prev: lib.mapAttrs (name: path: final.callPackage path { }) packageMap)
  ];
  environment.systemPackages = lib.mapAttrsToList (name: path: pkgs.callPackage path { }) packageMap;
}
