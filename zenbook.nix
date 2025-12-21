{ config, pkgs, ... }:

{
  imports = [
    ./hardware/intel-igpu.nix
    ./hardware/touchpad.nix
    ./software/gnome.nix
    ./software/programs.nix
    ./software/developing.nix
  ];

  networking.hostName = "ZenBook";

  services.udev.extraHwdb = ''
    evdev:name:GDX1515:00 27C6:01F4 Touchpad:dmi:*svnASUSTeKCOMPUTERINC.:*pnZenBookUX434FL_UX434FL**
      EVDEV_ABS_00=::60
      EVDEV_ABS_01=::60
      EVDEV_ABS_35=::60
      EVDEV_ABS_36=::60
  '';
}
