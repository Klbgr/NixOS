{ config, pkgs, ... }:

{
  imports = [
    ./hardware/intel-igpu.nix
    ./hardware/touchpad.nix
    ./software/kde.nix
    ./software/programs.nix
    ./software/developing.nix
  ];

  networking.hostName = "ZenBook";

  boot.extraModprobeConfig = ''
    options asus_wmi fnlock_default=0
  '';
}
