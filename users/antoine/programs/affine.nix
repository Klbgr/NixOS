{ ... }:

{
  home-manager.users.antoine =
    { lib, pkgs, ... }:

    {
      home.packages = with pkgs; [
        affine
      ];

      home.activation.mergeAffineConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        merge_json() {
          local DEST_FILE="$1"
          local WANTED_JSON="$2"
          local DIR
          DIR=$(dirname "$DEST_FILE")

          if [ ! -d "$DIR" ]; then
            mkdir -p "$DIR"
          fi

          if [ -f "$DEST_FILE" ]; then
            local TEMP_FILE
            TEMP_FILE=$(mktemp)
            ${pkgs.jq}/bin/jq -s '.[0] * .[1]' "$DEST_FILE" <(echo "$WANTED_JSON") > "$TEMP_FILE"
            mv "$TEMP_FILE" "$DEST_FILE"
          else
            echo "$WANTED_JSON" > "$DEST_FILE"
          fi
        }

        STATE_FILE="$HOME/.config/AFFiNE/global-state.json"
        CACHE_FILE="$HOME/.config/AFFiNE/global-cache.json"

        WANTED_STATE='{
          "menubarState": {
            "closeToTray": true,
            "enabled": true,
            "minimizeToTray": true,
            "openOnLeftClick": true,
            "startMinimized": true
          },
          "spellCheckState": {
            "enabled": true
          },
          "editor-setting": {
            "edgelessDefaultTheme": "\"auto\"",
            "edgelessScrollZoom": "true",
            "newDocDefaultMode": "\"page\"",
            "fullWidthLayout": "false",
            "displayDocInfo": "true",
            "displayBiDirectionalLink": "true"
          }
        }'

        WANTED_CACHE='{
          "i18n_lng": "fr"
        }'

        merge_json "$STATE_FILE" "$WANTED_STATE"
        merge_json "$CACHE_FILE" "$WANTED_CACHE"
      '';

      xdg.configFile."autostart/AFFiNE.desktop".text = ''
        [Desktop Entry]
        Type = Application
        Name = AFFiNE
        Exec = affine
      '';
    };
}
