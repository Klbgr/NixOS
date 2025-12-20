{ config, pkgs, ... }:

{
  imports = [
    ./intel-igpu.nix
    ./developing.nix
  ];

  networking.hostName = "ZenBook";

  environment.systemPackages = with pkgs; [
    fusuma
  ];

  programs.ydotool.enable = true;

  systemd.services.fusuma = {
    description = "Fusuma Daemon";
    wantedBy = [ "multi-user.target" ];
    path = [ pkgs.ydotool ];
    environment = {
      YDOTOOL_SOCKET = "/run/ydotoold/socket";
    };
    serviceConfig = {
      ExecStart = "${pkgs.fusuma}/bin/fusuma --config=/etc/nixos/additional-configurations/fusuma.yaml";
      Restart = "always";
      User = "root";
      Group = "ydotool";
    };
  };

  services.udev.extraHwdb = ''
    evdev:name:GDX1515:00 27C6:01F4 Touchpad:dmi:*svnASUSTeKCOMPUTERINC.:*pnZenBookUX434FL_UX434FL**
      EVDEV_ABS_00=::60
      EVDEV_ABS_01=::60
      EVDEV_ABS_35=::60
      EVDEV_ABS_36=::60
  '';
}
