{ pkgs, ... }:

{
  programs.plasma = {
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
      kwalletrc.Wallet.Enabled = false;
      kwinrc.Plugins.overviewEnabled = false;
    };

    immutableByDefault = true;

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
        wallpaperPictureOfTheDay = {
          provider = "bing";
          updateOverMeteredConnection = false;
        };
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

    overrideConfig = false;

    panels = [
      {
        alignment = "center";
        floating = true;
        height = 44;
        hiding = "none";
        lengthMode = "fill";
        location = "bottom";
        opacity = "adaptive";
        widgets = [
          {
            name = "org.kde.plasma.weather";
            config = {
              Appearance = {
                showPressureInTooltip = true;
                showTemperatureInCompactMode = true;
              };
              WeatherStation = {
                placeDisplayName = "Paris, France, FR";
                placeInfo = "Paris, France, FR|2988507";
                provider = "bbcukmet";
              };
            };
          }
          { panelSpacer.expanding = true; }
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
          "org.kde.plasma.pager"
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
          { panelSpacer.expanding = true; }
          {
            systemTray = {
              icons = {
                spacing = "small";
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
          "org.kde.plasma.showdesktop"
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

    windows.allowWindowsToRememberPositions = true;

    workspace = {
      enableMiddleClickPaste = true;
      clickItemTo = "select";
      lookAndFeel = "org.kde.breeze.desktop";
      wallpaper = "${pkgs.kdePackages.plasma-workspace-wallpapers}/share/wallpapers/Mountain/";
      wallpaperBackground.color = "0,0,0";
      wallpaperFillMode = "preserveAspectCrop";
    };
  };
}
