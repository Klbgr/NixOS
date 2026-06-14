{ ... }:

{
  home-manager.users.antoine =
    { pkgs, lib, ... }:

    {
      home.packages = with pkgs; [
        (symlinkJoin {
          name = "melonds-with-gamemoderun";
          paths = [
            (writeShellScriptBin "melonDS" ''
              exec ${gamemode}/bin/gamemoderun ${melonds}/bin/melonDS "$@"
            '')
            melonds
          ];
        })
      ];

      home.activation.mergeMelonDSConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        PATCHER="${pkgs.configuration-patcher}/bin/configuration-patcher"

        CONFIG_FILE="$HOME/.config/melonDS/melonDS.toml"

        $PATCHER toml "$CONFIG_FILE" '
          MuteFastForward = false
          SlowmoFPS = 30.0
          FastForwardFPS = 1000.0
          PauseLostFocus = false
          UITheme = ""
          AudioSync = true
          TargetFPS = 60.0
          LimitFPS = true

          [Instance0.DS.Battery]
          LevelOkay = true

          [Instance0.RTC]
          Offset = 0
          SyncToHost = true

          [Instance0.Window0]
          Enabled = true
          ScreenRotation = 0
          ScreenGap = 0
          ScreenLayout = 3
          ScreenSwap = false
          ScreenSizing = 0
          IntegerScaling = false
          ScreenAspectTop = 0
          ScreenAspectBot = 0
          ScreenFilter = true
          ShowOSD = true

          [Emu]
          ConsoleType = 0
          ExternalBIOSEnable = false
          DirectBoot = true

          [DS]
          BIOS9Path = ""
          BIOS7Path = ""
          FirmwarePath = ""

          [DSi]
          NANDPath = ""
          BIOS7Path = ""
          ExternalBIOSEnable = false
          BIOS9Path = ""
          FirmwarePath = ""

          [DSi.DSP]
          HLE = true

          [DSi.SD]
          Enable = false
          ImageSize = 0
          ImagePath = "dsisd.bin"
          ReadOnly = false
          FolderSync = false
          FolderPath = ""

          [JIT]
          Enable = false
          BranchOptimisations = true
          LiteralOptimisations = true
          FastMemory = true
          MaxBlockSize = 32

          [DLDI]
          Enable = false
          ImageSize = 0
          ImagePath = "dldi.bin"
          ReadOnly = false
          FolderSync = false
          FolderPath = ""

          [Instance0.Gdb]
          Enabled = false

          [Instance0.Gdb.ARM7]
          Port = 3334
          BreakOnStartup = false

          [Instance0.Gdb.ARM9]
          Port = 3333
          BreakOnStartup = false

          [3D]
          Renderer = 2

          [Screen]
          UseGL = true
          VSync = true
          VSyncInterval = 1

          [3D.Soft]
          Threaded = true

          [3D.GL]
          HiresCoordinates = true
          BetterPolygons = false

          [DSi.Camera0]
          XFlip = false
          InputType = 0
          ImagePath = ""
          DeviceName = ""

          [DSi.Camera1]
          XFlip = false
          InputType = 0
          ImagePath = ""
          DeviceName = ""

          [Audio]
          BitDepth = 0
          Interpolation = 0

          [Instance0.Audio]
          Volume = 256
          DSiVolumeSync = true

          [Mic]
          InputType = 1
          WavPath = ""

          [MP]
          RecvTimeout = 25
          AudioMode = 2

          [LAN]
          DirectMode = false
          Device = ""

          [Instance0.Firmware]
          Username = "melonDS"
          Language = 2
          FavouriteColour = 11
          BirthdayMonth = 2
          BirthdayDay = 5
          Message = ""
          OverrideSettings = false
          MAC = ""

          [Mouse]
          HideSeconds = 5
          Hide = true
        '
      '';
    };
}
