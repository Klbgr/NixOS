{ pkgs, ... }:
let
  run-steam-game = pkgs.writeShellScriptBin "run-steam-game" ''
    id=$1
    steam -silent steam://rungameid/"$id" &
    while ! tail -f -n 0 "$HOME/.local/share/Steam/logs/console_log.txt" | grep -q "Game process removed: AppID $id"
    do
      sleep 0.1
    done
  '';

  games-to-pegasus = pkgs.writers.writePython3Bin "games-to-pegasus" { } (
    builtins.readFile ../../../games-to-pegasus.py
  );
in
{
  home-manager.users.antoine =
    { pkgs, config, ... }:
    let
      gameOS-theme = pkgs.stdenv.mkDerivation rec {
        pname = "gameOS-theme";
        version = "master";
        src = pkgs.fetchFromGitHub {
          owner = "PlayingKarrde";
          repo = "gameOS";
          rev = version;
          sha256 = "sha256-EBpIe0aw1FO7DzB6F3oAWD5FRLF2iZGtOHllMxuamdc=";
        };
        installPhase = ''
          mkdir -p $out/share/pegasus-frontend/themes/gameOS

          cp -r ./* $out/share/pegasus-frontend/themes/gameOS/
        '';
      };
    in
    {
      home.packages = with pkgs; [
        pegasus-frontend
        skyscraper
        run-steam-game
        gameOS-theme
      ];

      xdg.configFile = {
        "pegasus-frontend/settings.txt".text = ''
          general.theme: ${config.home.homeDirectory}/.nix-profile/share/pegasus-frontend/themes/gameOS/
          general.verify-files: false
          general.input-mouse-support: true
          general.fullscreen: true
          providers.pegasus_media.enabled: true
          providers.steam.enabled: false
          providers.gog.enabled: false
          providers.es2.enabled: false
          providers.logiqx.enabled: false
          providers.lutris.enabled: false
          providers.skraper.enabled: false
          keys.page-up: PgUp,GamepadL2
          keys.page-down: PgDown,GamepadR2
          keys.prev-page: Q,A,GamepadL1
          keys.next-page: E,D,GamepadR1
          keys.menu: F1,GamepadStart
          keys.filters: F,GamepadY
          keys.details: I,GamepadX
          keys.cancel: Esc,Backspace,GamepadB
          keys.accept: Return,Enter,GamepadA
        '';
        "pegasus-frontend/game_dirs.txt".text = ''
          /games/Heroic/Pegasus
          /games/SteamLibrary/Pegasus
          /games/Switch/Pegasus
          /games/Wii/Pegasus
          /games/PS3/Pegasus
          /games/DS/Pegasus
        '';
        "pegasus-frontend/theme_settings/gameOS.json".text = ''
          {
            "Allow video thumbnails": "No",
            "Allow video thumbnailsIndex": 1,
            "Animate highlight": "No",
            "Animate highlightIndex": 0,
            "Blur Background": "No",
            "Blur BackgroundIndex": 0,
            "Default to full details": "Yes",
            "Default to full detailsIndex": 1,
            "Enable mouse hover": "No",
            "Enable mouse hoverIndex": 0,
            "Game Background": "Screenshot",
            "Game BackgroundIndex": 0,
            "Show scanlines": "No",
            "Show scanlinesIndex": 1,
            "Video preview": "No",
            "Video previewIndex": 1
          }
        '';
      };
    };

  systemd.services.games-to-pegasus = {
    description = "Import games to Pegasus";
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];
    path = [ pkgs.skyscraper ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${games-to-pegasus}/bin/games-to-pegasus";
      Restart = "no";
    };
  };
}
