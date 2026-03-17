{ ... }:

{
  home-manager.users.antoine =
    { pkgs, lib, ... }:

    {
      home.packages = with pkgs; [
        moonlight-qt
      ];

      home.activation.mergeMoonlightConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        PATCHER="${pkgs.configuration-patcher}/bin/configuration-patcher"

        CONFIG_FILE="$HOME/.config/Moonlight Game Streaming Project/Moonlight.conf"

        $PATCHER ini "$CONFIG_FILE" "General" "bitrate" "500000"
        $PATCHER ini "$CONFIG_FILE" "General" "windowmode" "1"
        $PATCHER ini "$CONFIG_FILE" "General" "vsync" "true"
        $PATCHER ini "$CONFIG_FILE" "General" "framepacing" "false"
        $PATCHER ini "$CONFIG_FILE" "General" "audiocfg" "0"
        $PATCHER ini "$CONFIG_FILE" "General" "hostaudio" "false"
        $PATCHER ini "$CONFIG_FILE" "General" "muteonfocusloss" "false"
        $PATCHER ini "$CONFIG_FILE" "General" "gameopts" "true"
        $PATCHER ini "$CONFIG_FILE" "General" "quitAppAfter" "false"
        $PATCHER ini "$CONFIG_FILE" "General" "language" "0"
        $PATCHER ini "$CONFIG_FILE" "General" "uidisplaymode" "0"
        $PATCHER ini "$CONFIG_FILE" "General" "connwarnings" "true"
        $PATCHER ini "$CONFIG_FILE" "General" "keepawake" "true"
        $PATCHER ini "$CONFIG_FILE" "General" "mouseacceleration" "false"
        $PATCHER ini "$CONFIG_FILE" "General" "capturesyskeys" "1"
        $PATCHER ini "$CONFIG_FILE" "General" "abstouchmode" "true"
        $PATCHER ini "$CONFIG_FILE" "General" "swapmousebuttons" "false"
        $PATCHER ini "$CONFIG_FILE" "General" "reversescroll" "false"
        $PATCHER ini "$CONFIG_FILE" "General" "swapfacebuttons" "false"
        $PATCHER ini "$CONFIG_FILE" "General" "multicontroller" "true"
        $PATCHER ini "$CONFIG_FILE" "General" "gamepadmouse" "true"
        $PATCHER ini "$CONFIG_FILE" "General" "backgroundgamepad" "false"
        $PATCHER ini "$CONFIG_FILE" "General" "videodec" "0"
        $PATCHER ini "$CONFIG_FILE" "General" "videocfg" "0"
        $PATCHER ini "$CONFIG_FILE" "General" "hdr" "false"
        $PATCHER ini "$CONFIG_FILE" "General" "yuv444" "false"
        $PATCHER ini "$CONFIG_FILE" "General" "unlockbitrate" "true"
        $PATCHER ini "$CONFIG_FILE" "General" "mdns" "true"
        $PATCHER ini "$CONFIG_FILE" "General" "detectnetblocking" "true"
        $PATCHER ini "$CONFIG_FILE" "General" "showperfoverlay" "false"
      '';
    };
}
