{ config, ... }:

{
  imports = [
    ./developing.nix
  ];

  networking.hostName = "ZenBook";
}
