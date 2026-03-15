{ ... }:

{
  home-manager.users.antoine =
    { pkgs, ... }:

    {
      home.packages = with pkgs; [
        kdePackages.kweather
      ];

      xdg.configFile."kweather/kweatherrc".text = ''
        [General]
        firstStartup=false

        [WeatherLocations][3031897]
        index=0
        latitude=48.81666946411133
        locationName=Boissy-sans-Avoir
        longitude=1.7999999523162842
        timezone=Europe/Paris
      '';
    };
}
