{ lib, ... }:
let
  dir = ./.;
  allFiles = builtins.readDir dir;
  nixFiles = builtins.filter (
    name: allFiles.${name} == "regular" && lib.hasSuffix ".nix" name && name != "default.nix"
  ) (builtins.attrNames allFiles);
  importsList = map (name: dir + "/${name}") nixFiles;
in
{
  imports = importsList ++ [ ../kde/kde-packages ];
}
