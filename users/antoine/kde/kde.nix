{ pkgs, ... }:

{
  nixpkgs.overlays = [
    (final: prev: {
      plasma-panel-colorizer = prev.plasma-panel-colorizer.overrideAttrs (oldAttrs: {
        nativeBuildInputs = (oldAttrs.nativeBuildInputs or [ ]) ++ [ final.jq ];
        postInstall = (oldAttrs.postInstall or "") + ''
          chmod 755 $out/share/plasma/plasmoids/luisbocanegra.panel.colorizer/contents/ui/tools/list_presets.sh
          TARGET_FILE="$out/share/plasma/plasmoids/luisbocanegra.panel.colorizer/contents/ui/presets/Transparent/settings.json"
          jq '.globalSettings.widgets.normal.shadow.foreground.enabled = false' "$TARGET_FILE" > temp.json && mv temp.json "$TARGET_FILE"
        '';
      });
    })
  ];

  home-manager.users.antoine =
    { pkgs, ... }:
    let
      plasma-manager = builtins.fetchTarball "https://github.com/pjones/plasma-manager/archive/trunk.tar.gz";
      burn-my-windows-kwin = pkgs.stdenv.mkDerivation {
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
      geometry-change-kwin = pkgs.stdenv.mkDerivation {
        pname = "geometry-change-kwin";
        version = "latest";
        src = pkgs.fetchurl {
          url = "https://github.com/peterfajdiga/kwin4_effect_geometry_change/releases/download/v1.5/kwin4_effect_geometry_change_1_5.tar.gz";
          hash = "sha256-dmUaJEZfg8gy65bcnTSzrBLHXRtxKYwqxGGopLLMCFA=";
        };
        installPhase = ''
          mkdir -p $out/share/kwin/effects/kwin4_effect_geometry_change
          cp -r * $out/share/kwin/effects/kwin4_effect_geometry_change/
        '';
      };
    in
    {
      imports = [
        "${plasma-manager}/modules"
      ];

      home.packages = with pkgs; [
        kdePackages.qtstyleplugin-kvantum
        kdePackages.dynamic-workspaces
        burn-my-windows-kwin
        geometry-change-kwin
        plasma-panel-colorizer
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
              sheetEnabled = true;
              dynamic_workspacesEnabled = true;
              kwin6_effect_aura_glowEnabled = false;
              kwin4_effect_geometry_changeEnabled = true;
            };
            kded5rc.Module-browserintegrationreminder.autoload = false;
            kwalletrc.Wallet.Enabled = false;
            krunnerrc.Plugins.krunner_appstreamEnabled = false;
            kuriikwsfilterrc.General.DefaultWebShortcut = "google";
          };

          immutableByDefault = false;

          input = {
            keyboard.numlockOnStartup = "on";
            mice = [
              {
                enable = true;
                acceleration = null;
                accelerationProfile = "none";
                leftHanded = false;
                middleButtonEmulation = false;
                name = "Logitech USB Receiver Mouse";
                naturalScroll = null;
                productId = "c548";
                scrollSpeed = null;
                vendorId = "046d";
              }
            ];
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
            lockOnStartup = true;
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
              slideBack.enable = true;
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
              alignment = "center";
              floating = true;
              height = 44;
              hiding = "none";
              lengthMode = "fill";
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
                { panelSpacer.expanding = true; }
                {
                  kickoff = {
                    icon = "distributor-logo-nixos";
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
                      "applications:chrome-gemini.google.com__-Default.desktop"
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
                        "org.kde.plasma.bluetooth"
                        "org.kde.kscreen"
                        "org.kde.plasma.devicenotifier"
                        "org.kde.plasma.printmanager"
                        "org.kde.kdeconnect"
                        "org.kde.plasma.weather"
                        "org.kde.plasma.trash"
                        "org.kde.plasma.manage-inputmethod"
                        "org.kde.plasma.clipboard"
                        "org.kde.plasma.diskquota"
                      ];
                      # shown = [ ];
                      # extra = [
                      #   "org.kde.plasma.keyboardlayout"
                      #   "org.kde.plasma.battery"
                      #   "org.kde.plasma.keyboardindicator"
                      #   "org.kde.plasma.cameraindicator"
                      #   "org.kde.plasma.brightness"
                      #   "org.kde.plasma.networkmanagement"
                      #   "org.kde.plasma.volume"
                      #   "org.kde.plasma.mediacontroller"
                      #   "org.kde.plasma.notifications"
                      # ];
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
                    # font = {
                    #   family = "Noto Sans";
                    #   bold = true;
                    #   italic = false;
                    #   weight = 600;
                    #   style = "SemiBold";
                    #   size = 10;
                    # };
                  };
                }
                "org.kde.plasma.minimizeall"
                {
                  plasmaPanelColorizer = {
                    general = {
                      enable = true;
                      hideWidget = true;
                    };
                    settings.General = {
                      presetAutoloading = builtins.toJSON {
                        enabled = true;
                        maximized = "${pkgs.plasma-panel-colorizer}/share/plasma/plasmoids/luisbocanegra.panel.colorizer/contents/ui/presets/Default";
                        normal = "${pkgs.plasma-panel-colorizer}/share/plasma/plasmoids/luisbocanegra.panel.colorizer/contents/ui/presets/Transparent";
                      };
                    };
                  };
                }
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
              whenSleepingEnter = "standbyThenHibernate";
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
              whenSleepingEnter = "standbyThenHibernate";
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
              whenSleepingEnter = "standbyThenHibernate";
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
            # "KDE Keyboard Layout Switcher"."Switch to Next Keyboard Layout" = [ "Meta+Space" ];
            plasmashell."activate task manager entry 1" = [ "Meta+C" ];
            "services/org.kde.plasma-systemmonitor.desktop"._launch = [
              "Ctrl+Shift+Esc"
            ];
            "services/org.kde.plasma.emojier.desktop"._launch = [
              "Meta+;"
              "Meta+."
            ];
            "services/cycle-output.desktop"._launch = [ "Meta+Tab" ];
            kwin."Walk Through Windows" = [ "Alt+Tab" ];
            kwin."Walk Through Windows (Reverse)" = [ "Alt+Shift+Tab" ];
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
            {
              apply = {
                above = {
                  apply = "force";
                  value = true;
                };
              };
              description = "System Monitor always on top";
              match = {
                machine = null;
                title = null;
                window-class = {
                  match-whole = true;
                  type = "exact";
                  value = "plasma-systemmonitor org.kde.plasma-systemmonitor";
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
            cursor = {
              animationTime = null;
              cursorFeedback = "None";
              taskManagerFeedback = true;
            };
            wallpaperBackground.color = "0,0,0";
            wallpaperFillMode = "preserveAspectCrop";
          };
        };
      };
    };

  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    khelpcenter
    elisa
    discover
  ];
}
