{ ... }:

{
  home-manager.users.antoine =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        ookla-speedtest
      ];

      xdg.configFile."ookla/speedtest-cli.json".text = ''
        {
            "Settings": {
                "LicenseAccepted": "604ec27f828456331ebf441826292c49276bd3c1bee1a2f65a6452f505c4061c",
                "GDPRTimeStamp": 1773584199
            }
        }
      '';
    };
}
