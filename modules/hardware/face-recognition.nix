{ lib, ... }:

{
  services.howdy = {
    enable = true;
    control = "sufficient";
    settings.core = {
      no_confirmation = true;
      detection_notice = true;
      workaround = "native";
    };
  };

  security.pam.howdy.enable = true;

  systemd.services."polkit-agent-helper@" = {
    serviceConfig = {
      PrivateDevices = lib.mkForce false;
      DeviceAllow = [
        "char-video4linux rw"
        "/dev/uinput rw"
      ];
    };
  };
}
