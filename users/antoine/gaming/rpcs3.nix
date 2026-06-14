{ inputs, pkgs, ... }:
let
  rpcs3-nixpkgs = import inputs.rpcs3-nixpkgs {
    inherit (pkgs) system;
  };
in
{
  home-manager.users.antoine =
    { pkgs, lib, ... }:

    {
      home.packages = with pkgs; [
        (symlinkJoin {
          name = "rpcs3-with-gamemoderun-mangohud";
          paths = [
            (writeShellScriptBin "rpcs3" ''
              exec ${gamemode}/bin/gamemoderun ${mangohud}/bin/mangohud ${rpcs3-nixpkgs.rpcs3}/bin/rpcs3 "$@"
            '')
            rpcs3-nixpkgs.rpcs3
          ];
        })
      ];

      home.activation.mergeRPCS3Config = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        PATCHER="${pkgs.configuration-patcher}/bin/configuration-patcher"

        CONFIG_FILE="$HOME/.config/rpcs3/config.yml"
        GUI_CONFIG_FILE="$HOME/.config/rpcs3/GuiConfigs/CurrentSettings.ini"

        $PATCHER yaml "$CONFIG_FILE" '
          Core:
            PPU Decoder: Recompiler (LLVM)
            SPU Decoder: Recompiler (LLVM)
            XFloat Accuracy: Approximate
            SPU Block Size: Safe
            SPU loop detection: false
            Max CPU Preempt Count: 0
            Preferred SPU Threads: 0
            Thread Scheduler Mode: Operating System

            Debug Console Mode: false
            Use Accurate DFMA: true
            Accurate RSX reservation access: false
            Accurate SPU DMA: false
            Disable SPU GETLLAR Spin Optimization: false
            SPU Reservation Busy Waiting Enabled: false

            LLVM Precompilation: true
            MFC Commands Shuffling In Steps: false
            Sleep Timers Accuracy: As Host
            Max SPURS Threads: 6
            Clocks scale: 100
            RSX FIFO Fetch Accuracy: Atomic

            Max LLVM Compile Threads: 0
          VFS:
            Limit disk cache size: false
            Disk cache maximum size (MB): 5120

            Enable /host_root/: false
            Empty /dev_hdd0/tmp/: true
          Video:
            Renderer: Vulkan
            Aspect ratio: 16:9
            Frame limit: Display
            Anisotropic Filter Override: 16
            MSAA: Auto
            Accurate ZCULL stats: true
            Shader Precision: Ultra
            3D Display Enabled: false
            3D Display Mode: Disabled
            Resolution: 1280x720
            Minimum Scalable Dimension: 16
            Output Scaling Mode: FidelityFX Super Resolution
            Shader Mode: Async Shader Recompiler
            Write Color Buffers: false
            Strict Rendering Mode: false
            VSync: true
            Stretch To Display Area: false
            Multithreaded RSX: false

            Read Depth Buffer: false
            Write Depth Buffer: false
            Read Color Buffers: false
            Handle RSX Memory Tiling: false
            Disable Vertex Cache: false
            Allow Host GPU Labels: false
            Force Hardware MSAA Resolve: false
            Driver Wake-Up Delay: 0
            Vblank Rate: 60
            Vblank NTSC Fixup: false

            Record With Overlays: true
            Shader Compiler Threads: 0
            Vulkan:
              FidelityFX CAS Sharpening Intensity: 75
              Asynchronous Texture Streaming 2: false

              Use Re-BAR for GPU uploads: true
              Exclusive Fullscreen Mode: Automatic
            Performance Overlay:
              Enabled: false
              Enable Framerate Graph: false
              Enable Frametime Graph: false
              Detail level: Medium
              Position: Top Left
              Center Horizontally: false
              Horizontal Margin (px): 50
              Center Vertically: false
              Vertical Margin (px): 50
              Metrics update interval (ms): 350
              Font size (px): 10
              Opacity (%): 70
              Framerate datapoints: 50
              Frametime datapoints: 170
            Shader Loading Dialog:
              Allow custom background: true
              Darkening effect strength: 30
              Blur effect strength: 0
          Audio:
            Renderer: Cubeb
            Audio Format: Stereo
            Audio Formats: 0
            Convert to 16 bit: false
            Microphone Type: "Null"
            Audio Channel Layout: Automatic
            Music Handler: Qt
            Master Volume: 100
            Enable Buffering: true
            Desired Audio Buffer Duration: 34
            Enable Time Stretching: false
            Time Stretching Threshold: 75
          Input/Output:
            Keyboard: "Null"
            Mouse: Basic
            Move: "Null"
            Pad handler mode: Single-threaded
            Background input enabled: true
            Keep pads connected: false
            Show move cursor: false
            Lock overlay input to player one: false
            Load SDL GameController Mappings: true
            Camera type: Unknown
            Camera: "Null"
            Camera ID: Default
            SDL Camera ID: Default
            Camera flip: None
            Buzz emulated controller: "Null"
            Turntable emulated controller: "Null"
            GHLtar emulated controller: "Null"
          System:
            Language: French
            License Area: SCEE
            Enter button assignment: Enter with cross
            Keyboard Type: French keyboard
            Date Format: ddmmyyyy
            Time Format: clock24
            Console time offset (s): 0
          Net:
            Internet enabled: Disconnected
            DNS address: 8.8.8.8
            IP swap list: ""
            Bind address: 0.0.0.0
            IP address: 0.0.0.0
            UPNP Enabled: false
            PSN status: Disconnected
            PSN Country: fr
            Clans Enabled: false
          Savestate:
            Suspend Emulation Savestate Mode: false
            Inspection Mode Savestates: false
            Compatible Savestate Mode: false
          Miscellaneous:
            Silence All Logs: false

            Exit RPCS3 when process finishes: false
            Pause emulation on RPCS3 focus loss: false
            Pause Emulation During Home Menu: false
            Prevent display sleep while running games: true
            Show trophy popups: true
            Show RPCN popups: true
            Show shader compilation hint: true
            Show PPU compilation hint: true
            Show autosave/autoload hint: false
            Show analog limiter toggle hint: true
            Show pressure intensity toggle hint: true
            Show mouse and keyboard toggle hint: true
            Show capture hints: true
            Start games in fullscreen mode: false
            Use native user interface: true
            Enable GameMode: true
            Window Title Format: "FPS: %F | %R | %V | %T [%t]"
        '

        $PATCHER ini "$GUI_CONFIG_FILE" '
          [Localization]
          language = en

          [Meta]
          checkUpdateStart = false
          currentStylesheet = default
          discordState = ""
          useRichPresence = true

          [main_window]
          infoBoxEnabledWelcome = false
        '
      '';
    };
}
