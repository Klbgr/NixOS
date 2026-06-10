{ ... }:

{
  home-manager.users.antoine =
    {
      inputs,
      pkgs,
      lib,
      ...
    }:
    let
      spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
    in
    {
      imports = [
        inputs.spicetify-nix.homeManagerModules.spicetify
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

        $PATCHER ini-legacy "$CONFIG_FILE" "" "language" '"fr"'
      '';

      xdg.configFile."autostart/Spotify.desktop".text = ''
        [Desktop Entry]
        Type = Application
        Name = Spotify
        Exec = spotify --minimized
      '';
    };
}
