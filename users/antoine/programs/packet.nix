{ ... }:

{
  home-manager.users.antoine =
    {
      config,
      pkgs,
      ...
    }:

    {
      home.packages = with pkgs; [
        packet
      ];

      dconf.settings = {
        "io/github/nozwock/Packet" = {
          auto-start = false;
          device-visibility = true;
          download-folder = "${config.home.homeDirectory}/Downloads";
          enable-nautilus-plugin = false;
          enable-static-port = true;
          run-in-background = true;
          static-port-number = 9300;
        };
      };

      xdg.configFile."autostart/Packet.desktop".text = ''
        [Desktop Entry]
        Type = Application
        Name = Packet
        Exec = packet -b
      '';
    };

  networking.firewall.allowedTCPPorts = [
    9300
  ];
}
