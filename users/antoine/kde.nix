{ pkgs, ... }:
let
  burn-my-windows-kwin = pkgs.stdenv.mkDerivation rec {
    pname = "burn-my-windows-kwin";
    version = "latest";
    src = pkgs.fetchurl {
      url = "https://github.com/Schneegans/Burn-My-Windows/releases/latest/download/burn_my_windows_kwin6.tar.gz";
      hash = "sha256-kEvBB1ST1J0OxjEXLl5UIPNxjclzAshEYSA/TQwZ3Qo=";
    };
    sourceRoot = ".";
    installPhase = ''
      mkdir -p $out/share/kwin/effects
      cp -r * $out/share/kwin/effects/
    '';
  };
in
{
  imports = [
    ../../software/modules/plasma-manager.nix
    ./themes/dream.nix
  ];

  home.packages = with pkgs; [
    kdePackages.qtstyleplugin-kvantum
    kdePackages.dynamic-workspaces
    # kdePackages.koi
    burn-my-windows-kwin
  ];

  qt = {
    enable = true;
    platformTheme.name = "kde";
  };

  programs = {
    konsole = {
      enable = true;
      defaultProfile = "Custom";
      profiles = {
        custom = {
          name = "Custom";
        };
      };
    };

    plasma = {
      enable = true;

      configFile = {
        ktrashrc."\\/home\\/antoine\\/.local\\/share\\/Trash" = {
          Days = 14;
          LimitReachedAction = 0;
          Percent = 10;
          UseSizeLimit = true;
          UseTimeLimit = true;
        };
        plasmaparc.General.AudioFeedback = false;
        kwinrc.Plugins = {
          overviewEnabled = false;
          dynamic_workspacesEnabled = true;
          kwin6_effect_aura_glowEnabled = false;
        };
        kded5rc.Module-browserintegrationreminder.autoload = false;
        # koirc.General.start-hidden=1;
        "autostart/Discord.desktop"."Desktop Entry" = {
          Type = "Application";
          Name = "Discord";
          Exec = "discord --start-minimized";
        };
        "autostart/RQuickShare.desktop"."Desktop Entry" = {
          Type = "Application";
          Name = "RQuickShare";
          Exec = "rquickshare";
        };
        "autostart/Spotify.desktop"."Desktop Entry" = {
          Type = "Application";
          Name = "Spotify";
          Exec = "spotify --minimized";
        };
        "autostart/EasyEffects.desktop"."Desktop Entry" = {
          Type = "Application";
          Name = "Easy Effects";
          Exec = "easyeffects --hide-window";
        };
        "easyeffects/db/easyeffectsrc".Window.showTrayIcon = false;
      };

      immutableByDefault = false;

      input = {
        keyboard = {
          layouts = [
            { layout = "fr"; }
            { layout = "us"; }
          ];
          model = "pc104";
          numlockOnStartup = "on";
          options = [ "caps:digits_row" ];
        };

        touchpads = [
          {
            enable = true;
            accelerationProfile = "default";
            disableWhileTyping = false;
            leftHanded = false;
            middleButtonEmulation = false;
            name = "GDX1515:00 27C6:01F4 Touchpad";
            naturalScroll = true;
            pointerSpeed = 0.0;
            productId = "01f4";
            rightClickMethod = "twoFingers";
            scrollMethod = "twoFingers";
            scrollSpeed = 0.3;
            tapAndDrag = true;
            tapDragLock = true;
            tapToClick = true;
            twoFingerTap = "rightClick";
            vendorId = "27c6";
          }
        ];
      };

      krunner = {
        activateWhenTypingOnDesktop = true;
        historyBehavior = "enableSuggestions";
        position = "top";
        shortcuts = {
          launch = "Alt+Space";
        };
      };

      kscreenlocker = {
        appearance = {
          alwaysShowClock = true;
          showMediaControls = true;
          # wallpaperPictureOfTheDay = {
          #   provider = "bing";
          #   updateOverMeteredConnection = false;
          # };
        };
        autoLock = true;
        lockOnResume = true;
        lockOnStartup = false;
        passwordRequired = true;
        passwordRequiredDelay = 5;
        timeout = 5;
      };

      kwin = {
        cornerBarrier = true;
        edgeBarrier = 100;
        effects = {
          blur = {
            enable = true;
            noiseStrength = 5;
            strength = 15;
          };
          cube.enable = false;
          desktopSwitching = {
            animation = "slide";
            navigationWrapping = false;
          };
          dimAdminMode.enable = true;
          dimInactive.enable = false;
          fallApart.enable = false;
          fps.enable = false;
          hideCursor.enable = false;
          invert.enable = false;
          magnifier.enable = false;
          minimization.animation = "squash";
          shakeCursor.enable = true;
          slideBack.enable = false;
          snapHelper.enable = false;
          translucency.enable = true;
          windowOpenClose.animation = "scale";
          wobblyWindows.enable = true;
          zoom.enable = false;
        };
        nightLight.enable = false;
        scripts = {
          polonium.enable = false;
        };
        titlebarButtons = {
          left = [ ];
          right = [
            "minimize"
            "maximize"
            "close"
          ];
        };
      };

      overrideConfig = true;

      panels = [
        {
          alignment = "left";
          floating = true;
          height = 44;
          hiding = "none";
          lengthMode = "fit";
          location = "bottom";
          opacity = "translucent";
          widgets = [
            {
              pager = {
                general = {
                  showWindowOutlines = true;
                  showApplicationIconsOnWindowOutlines = true;
                  showOnlyCurrentScreen = false;
                  navigationWrapsAround = false;
                  displayedText = "none";
                  selectingCurrentVirtualDesktop = "doNothing";
                };
              };
            }
          ];
        }
        {
          alignment = "center";
          floating = true;
          height = 44;
          hiding = "none";
          lengthMode = "fit";
          location = "bottom";
          opacity = "translucent";
          widgets = [
            {
              kickoff = {
                sortAlphabetically = true;
                compactDisplayStyle = false;
                sidebarPosition = "left";
                favoritesDisplayMode = "grid";
                applicationsDisplayMode = "list";
                showButtonsFor = "powerAndSession";
                showActionButtonCaptions = true;
              };
            }
            {
              iconTasks = {
                launchers = [
                  "applications:org.kde.konsole.desktop"
                  "applications:org.kde.dolphin.desktop"
                  "applications:google-chrome.desktop"
                ];
                iconsOnly = true;
                appearance = {
                  showTooltips = true;
                  highlightWindows = true;
                  indicateAudioStreams = true;
                  fill = true;
                  rows.multirowView = "never";
                  iconSpacing = "medium";
                };
                behavior = {
                  grouping = {
                    method = "byProgramName";
                    clickAction = "cycle";
                  };
                  sortingMethod = "manually";
                  minimizeActiveTaskOnClick = true;
                  middleClickAction = "newInstance";
                  wheel.switchBetweenTasks = false;
                  showTasks = {
                    onlyInCurrentScreen = false;
                    onlyInCurrentDesktop = true;
                    onlyInCurrentActivity = true;
                    onlyMinimized = false;
                  };
                  unhideOnAttentionNeeded = true;
                  newTasksAppearOn = "right";
                };

              };
            }
          ];
        }
        {
          alignment = "right";
          floating = true;
          height = 44;
          hiding = "none";
          lengthMode = "fit";
          location = "bottom";
          opacity = "translucent";
          widgets = [
            {
              systemTray = {
                icons = {
                  spacing = "medium";
                  scaleToFit = false;
                };
                items = {
                  showAll = false;
                  hidden = [
                    "org.kde.plasma.clipboard"
                    "org.kde.plasma.weather"
                  ];
                };
              };
            }
            {
              digitalClock = {
                date = {
                  enable = true;
                  format = "shortDate";
                  position = "adaptive";
                };
                time = {
                  showSeconds = "onlyInTooltip";
                  format = "default";
                };
                timeZone = {
                  selected = [ "Local" ];
                  lastSelected = "Local";
                  changeOnScroll = false;
                  format = "code";
                };
                calendar = {
                  firstDayOfWeek = null;
                };
              };
            }
            "org.kde.plasma.minimizeall"
          ];
        }
      ];

      powerdevil = {
        AC = {
          autoSuspend = {
            action = "sleep";
            idleTimeout = 900;
          };
          dimDisplay.enable = false;
          dimKeyboard.enable = false;
          inhibitLidActionWhenExternalMonitorConnected = false;
          powerButtonAction = "showLogoutScreen";
          powerProfile = "performance";
          turnOffDisplay = {
            idleTimeout = 600;
            idleTimeoutWhenLocked = 60;
          };
          whenLaptopLidClosed = "sleep";
        };
        battery = {
          autoSuspend = {
            action = "sleep";
            idleTimeout = 600;
          };
          dimDisplay.enable = false;
          dimKeyboard.enable = false;
          inhibitLidActionWhenExternalMonitorConnected = false;
          powerButtonAction = "showLogoutScreen";
          powerProfile = "balanced";
          turnOffDisplay = {
            idleTimeout = 300;
            idleTimeoutWhenLocked = 60;
          };
          whenLaptopLidClosed = "sleep";
        };
        lowBattery = {
          autoSuspend = {
            action = "sleep";
            idleTimeout = 300;
          };
          dimDisplay.enable = true;
          dimKeyboard.enable = false;
          displayBrightness = 30;
          inhibitLidActionWhenExternalMonitorConnected = false;
          powerButtonAction = "showLogoutScreen";
          powerProfile = "powerSaving";
          turnOffDisplay = {
            idleTimeout = 120;
            idleTimeoutWhenLocked = 60;
          };
          whenLaptopLidClosed = "sleep";
        };
        batteryLevels = {
          criticalAction = "sleep";
          criticalLevel = 5;
          lowLevel = 20;
        };
        general.pausePlayersOnSuspend = true;
      };

      session = {
        general.askForConfirmationOnLogout = true;
        sessionRestore = {
          restoreOpenApplicationsOnLogin = "onLastLogout";
        };
      };

      shortcuts = {
        "services/org.kde.plasma-systemmonitor.desktop"._launch = [
          "Ctrl+Shift+Esc"
        ];
        "services/org.kde.plasma.emojier.desktop"._launch = [
          "Meta+;"
          "Meta+."
        ];
      };

      window-rules = [
        {
          apply = {
            above = {
              apply = "force";
              value = true;
            };
          };
          description = "PIP always on top";
          match = {
            machine = null;
            title = {
              type = "exact";
              value = "Mode PIP (Picture-in-Picture)";
            };
            window-class = {
              match-whole = false;
              type = "exact";
              value = "chrome";
            };
            window-role = null;
            window-types = [ "normal" ];
          };
        }
      ];

      windows.allowWindowsToRememberPositions = true;

      workspace = {
        enableMiddleClickPaste = true;
        clickItemTo = "select";
        wallpaperBackground.color = "0,0,0";
        wallpaperFillMode = "preserveAspectCrop";
      };
    };
  };
}
