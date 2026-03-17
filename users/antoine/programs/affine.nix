{ ... }:

{
  home-manager.users.antoine =
    { lib, pkgs, ... }:

    {
      home.packages = with pkgs; [
        affine
      ];

      home.activation.mergeAffineConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        PATCHER="${pkgs.configuration-patcher}/bin/configuration-patcher"

        STATE_FILE="$HOME/.config/AFFiNE/global-state.json"
        CACHE_FILE="$HOME/.config/AFFiNE/global-cache.json"

        $PATCHER json "$STATE_FILE" '{
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

        $PATCHER json "$CACHE_FILE" '{
          "i18n_lng": "fr"
        }'
      '';

      xdg.configFile."autostart/AFFiNE.desktop".text = ''
        [Desktop Entry]
        Type = Application
        Name = AFFiNE
        Exec = affine
      '';
    };
}
