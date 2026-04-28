{ pkgs, ... }:

{
  services.xserver.enable = true;

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
          interval: 0.1
        down:
          command: "ydotool key 114:1 114:0"
          threshold: 0.0
          interval: 0.1
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
        threshold: 0.0
  '';
}
