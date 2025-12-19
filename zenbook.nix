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
}
