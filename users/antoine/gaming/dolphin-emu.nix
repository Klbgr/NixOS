{ ... }:

{
  home-manager.users.antoine =
    { pkgs, lib, ... }:

    {
      home.packages = with pkgs; [
        (symlinkJoin {
          name = "dolphin-with-gamemoderun-mangohud";
          paths = [
            (writeShellScriptBin "dolphin-emu" ''
              exec ${gamemode}/bin/gamemoderun ${mangohud}/bin/mangohud ${dolphin-emu}/bin/dolphin-emu "$@"
            '')
            dolphin-emu
          ];
        })
      ];

      home.activation.mergeDolphinConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        PATCHER="${pkgs.configuration-patcher}/bin/configuration-patcher"

        DOLPHIN_CONFIG_FILE="$HOME/.config/dolphin-emu/Dolphin.ini"
        GFX_CONFIG_FILE="$HOME/.config/dolphin-emu/GFX.ini"
        QT_CONFIG_FILE="$HOME/.config/dolphin-emu/Qt.ini"

        $PATCHER ini "$DOLPHIN_CONFIG_FILE" '
          [Analytics]
          PermissionAsked = True
          Enabled = False
          [Core]
          CPUThread = False
          LoadGameIntoMemory = False
          OverrideRegionSettings = False
          AutoDiscChange = False
          EmulationSpeed = 1.0
          FallbackRegion = 2

          GFXBackend = Vulkan
          PrecisionFrameTiming = True

          DSPHLE = True
          DPL2Decoder = False
          DPL2Quality = 2
          AudioBufferSize = 80
          AudioFillGaps = True
          AudioPreservePitch = False

          SelectedLanguage = 2

          WiiKeyboard = False
          EnableWiiLink = False
          WiiSDCard = True
          WiiSDCardAllowWrites = True
          WiiSDCardEnableFolderSync = False
          WiiSDCardFilesize = 0x0000000000000000

          CPUCore = 1
          MMU = False
          PauseOnPanic = False
          AccurateCPUCache = False
          CorrectTimeDrift = False
          RushFramePresentation = False
          SmoothEarlyPresentation = False
          OverclockEnable = False
          Overclock = 1.
          VIOverclockEnable = False
          VIOverclock = 1.
          RAMOverrideEnable = False
          MEM1Size = 0x01800000
          MEM2Size = 0x04000000
          EnableCustomRTC = False
          CustomRTCValue = 0x386d4380
          [General]
          UseDiscordPresence = True

          UseGameCovers = False
          HotkeysRequireFocus = True
          EnablePlayTimeTracking = True

          ShowFrameCount = False
          ShowLag = False

          RecursiveISOPaths = True
          [Interface]
          LanguageCode = 
          ThemeName = Clean
          UseBuiltinTitleDatabase = True
          DebugModeEnabled = False
          ConfirmStop = True
          UsePanicHandlers = True
          ShowActiveTitle = True
          PauseOnFocusLost = False
          CursorVisibility = 2

          OnScreenDisplayMessages = True
          [NetPlay]
          TraversalChoice = direct
          [DSP]
          Backend = Cubeb
          MuteOnDisabledSpeedLimit = False
          Volume = 100
          [Display]
          Fullscreen = False
          RenderToMain = False
          RenderWindowAutoSize = False

          DisableScreenSaver = True
          KeepWindowOnTop = False
          [GBA]
          Threads = True
          SavesInRomPath = False
          [Movie]
          ShowMovieWindow = False
          ShowRerecord = False
          ShowInputDisplay = False
          ShowRTC = False
          [Settings]
          OSDFontSize = 13                
        '

        $PATCHER ini "$GFX_CONFIG_FILE" '
          [ColorCorrection]
          CorrectColorSpace = False
          GameColorSpace = 0
          GameGamma = 2.35
          CorrectGamma = False
          SDRDisplayGammaSRGB = False
          SDRDisplayCustomGamma = 2.2
          HDRPaperWhiteNits = 203.
          [Enhancements]
          ForceTextureFiltering = 0
          MaxAnisotropy = 4
          OutputResampling = 3
          PostProcessingShader = 
          ForceTrueColor = True
          ArbitraryMipmapDetection = False
          DisableCopyFilter = True
          HDROutput = False
          [Hardware]
          VSync = True
          [Settings]
          AspectRatio = 0
          ShaderCompilationMode = 2
          WaitForShadersBeforeStarting = False

          MSAA = 0x00000008
          SSAA = True
          EnablePixelLighting = False
          wideScreenHack = False
          DisableFog = False

          EnableGPUTextureDecoding = False
          SafeTextureCacheColorSamples = 128
          FastDepthCalc = True
          SaveTextureCacheToState = True

          WireFrame = False
          TexFmtOverlayEnable = False
          EnableValidationLayer = False
          LogRenderTimeToFile = False
          HiresTextures = False
          CacheHiresTextures = False
          EnableMods = False
          DumpEFBTarget = False
          DumpXFBTarget = False
          DumpTextures = False
          DumpBaseTextures = True
          DumpMipTextures = True
          FrameDumpsResolutionType = 1
          UseLossless = False
          BitrateKbps = 25000
          PNGCompressionLevel = 6
          Crop = False
          BackendMultithreading = True
          PreferVSForLinePointExpansion = False
          CPUCull = False

          PerfSampWindowMS = 900
          ShowFPS = False
          ShowFTimes = False
          ShowVPS = False
          ShowVTimes = False
          ShowSpeed = False
          ShowGraphs = False
          ShowSpeedColors = True
          ShowNetPlayPing = False
          ShowNetPlayMessages = False
          OverlayStats = False
          OverlayProjStats = False
          [Hacks]
          EFBScaledCopy = True

          EFBAccessEnable = False
          EFBEmulateFormatChanges = False
          EFBToTextureEnable = True
          DeferEFBCopies = True

          XFBToTextureEnable = True
          ImmediateXFBEnable = False
          SkipDuplicateXFBs = True
          BBoxEnable = False
          VertexRounding = False
          VISkip = False

          DisableCopyToVRAM = False
          EFBAccessDeferInvalidation = False
          FastTextureSampling = True
          [Stereoscopy]
          StereoMode = 0
          StereoDepth = 20.
          StereoConvergence = 20.
          StereoSwapEyes = False
          StereoPerEyeResolutionFull = False
        '

        $PATCHER ini "$QT_CONFIG_FILE" '
          [userstyle]
          styletype=0
        '
      '';
    };
}
