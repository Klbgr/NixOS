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

        $PATCHER ini "$CONFIG_FILE" '
          [General]
          bitrate = 300000
          windowmode = 1
          vsync = true
          framepacing = false
          audiocfg = 0
          hostaudio = false
          muteonfocusloss = false
          gameopts = true
          quitAppAfter = true
          language = 0
          uidisplaymode = 0
          connwarnings = true
          keepawake = true
          mouseacceleration = false
          capturesyskeys = 1
          abstouchmode = true
          swapmousebuttons = false
          reversescroll = false
          swapfacebuttons = false
          multicontroller = true
          gamepadmouse = true
          backgroundgamepad = false
          videodec = 0
          videocfg = 0
          hdr = false
          yuv444 = false
          unlockbitrate = true
          mdns = true
          detectnetblocking = true
          showperfoverlay = false
        '
      '';
    };
}
