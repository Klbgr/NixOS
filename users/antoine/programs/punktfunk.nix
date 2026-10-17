{ inputs, ... }:

{
  imports = [ inputs.punktfunk.nixosModules.default ];

  home-manager.users.antoine =
    { lib, pkgs, ... }:

    {
        home.activation.mergePunktfunkConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
          PATCHER="${pkgs.configuration-patcher}/bin/configuration-patcher"

          DISPLAY_FILE="$HOME/.config/punktfunk/display-settings.json"
          SESSION_FILE="$HOME/.config/punktfunk/session-settings.json"
          HOST_FILE="$HOME/.config/punktfunk/host-settings.json"

          $PATCHER json "$DISPLAY_FILE" '{
            "preset": "custom",
            "keep_alive": {
              "mode": "off"
            },
            "topology": "auto",
            "mode_conflict": "join",
            "identity": "per-client",
            "max_displays": 4,
            "game_session": "auto",
            "launch_workspace": "own",
            "ddc_power_off": false,
            "pnp_disable_monitors": false,
            "edid_lock": false,
            "capture_monitor": null
          }'

          $PATCHER json "$SESSION_FILE" '{
            "game_on_session_end": "keep",
            "session_on_game_exit": false,
            "game_on_new_launch": "keep",
            "disconnect_grace_seconds": 300
          }'

          $PATCHER json "$HOST_FILE" '{
            "audio_output_mode": "client_only",
            "clipboard": "files",
            "gamescope_hdr": false,
            "ten_bit": false,
            "tray_autostart": true,
            "webtransport": true
          }'
        '';
    };

  services.punktfunk.host = {
    enable = true;
    gamestream = false;
    autoStart = true;
    users = [ "antoine" ];
    openFirewall = true;
    desktopSession = true;
    gamescopeHdr = true;
    settings = {
      PUNKTFUNK_VIDEO_SOURCE = "virtual";
    };
  };

  services.punktfunk.client = {
    enable = true;
    openFirewall = true;
  };
}
