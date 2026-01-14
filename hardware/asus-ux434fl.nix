{ config, pkgs, ... }:

{
  imports = [
    ./modules/intel-igpu.nix
    ./modules/touchpad.nix
    ./modules/logitech.nix
  ];

  networking.hostName = "ZenBook";

  boot.extraModprobeConfig = ''
    options asus_wmi fnlock_default=0
  '';
}
