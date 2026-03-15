{ ... }:

{
  home-manager.users.antoine =
    { lib, ... }:
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
        merge_spotify_pref() {
          local PREFS_FILE="$HOME/.config/spotify/prefs"
          local KEY="$1"
          local VALUE="$2"
          local LINE="$KEY=\"$VALUE\""

          mkdir -p "$(dirname "$PREFS_FILE")"
          touch "$PREFS_FILE"

          if grep -q "^$KEY=" "$PREFS_FILE"; then
            sed -i "s|^$KEY=.*|$LINE|" "$PREFS_FILE"
          else
            echo "$LINE" >> "$PREFS_FILE"
          fi
        }

        merge_spotify_pref "language" "fr"
      '';

      xdg.configFile."autostart/Spotify.desktop".text = ''
        [Desktop Entry]
        Type = Application
        Name = Spotify
        Exec = spotify --minimized
      '';
    };
}
