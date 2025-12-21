{ config, pkgs, ... }:

{
  imports = [
    ./hardware/intel-igpu.nix
    ./software/gnome.nix
    ./software/programs.nix
    ./software/developing.nix
  ];

  networking.hostName = "ZenBook";

  environment.systemPackages = with pkgs; [
    fusuma
  ];

  programs.ydotool.enable = true;

  systemd.services.fusuma = {
    description = "Fusuma Daemon";
    after = [ "graphical.target" ];
    wantedBy = [ "graphical.target" ];
    path = [ pkgs.ydotool ];
    environment = {
      YDOTOOL_SOCKET = "/run/ydotoold/socket";
    };
    serviceConfig = {
      ExecStart = "${pkgs.fusuma}/bin/fusuma --config=/etc/fusuma/config.yaml";
      Restart = "always";
      User = "root";
      Group = "ydotool";
    };
    enable = true;
  };

  environment.etc."fusuma/config.yaml".text = ''
    swipe:
      4:
        up:
          command: "ydotool key 115:1 115:0"
          threshold: 0.0
          interval: 0.25
        down:
          command: "ydotool key 114:1 114:0"
          threshold: 0.0
          interval: 0.25
        left:
          command: "ydotool key 165:1 165:0"
          threshold: 1.0
          interval: 1.0
        right:
          command: "ydotool key 163:1 163:0"
          threshold: 1.0
          interval: 1.0

    hold:
      4:
        command: "ydotool key 164:1 164:0"
        threshold: 0.25
  '';

  services.udev.extraHwdb = ''
    evdev:name:GDX1515:00 27C6:01F4 Touchpad:dmi:*svnASUSTeKCOMPUTERINC.:*pnZenBookUX434FL_UX434FL**
      EVDEV_ABS_00=::60
      EVDEV_ABS_01=::60
      EVDEV_ABS_35=::60
      EVDEV_ABS_36=::60
  '';
}
