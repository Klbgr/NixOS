{ ... }:

{
  home-manager.users.antoine =
    { pkgs, lib, ... }:
    let
      spicetify-nix = import (builtins.fetchTarball {
        url = "https://github.com/Gerg-L/spicetify-nix/archive/master.tar.gz";
      }) { };
      spicePkgs = spicetify-nix.packages;
    in
    {
      imports = [
        spicetify-nix.homeManagerModules.spicetify
      ];

      programs.spicetify = {
        enable = true;
        theme = spicePkgs.themes.defaultDynamic;
        colorScheme = "Dark-Base";
        enabledCustomApps = [
          spicePkgs.apps.ncsVisualizer
        ];
      };

      home.activation.mergeSpotifyConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        PATCHER="${pkgs.configuration-patcher}/bin/configuration-patcher"

        CONFIG_FILE="$HOME/.config/spotify/prefs"

        $PATCHER ini "$CONFIG_FILE" "" "language" '"fr"'
      '';

      xdg.configFile."autostart/Spotify.desktop".text = ''
        [Desktop Entry]
        Type = Application
        Name = Spotify
        Exec = spotify --minimized
      '';
    };
}
