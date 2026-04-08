{ pkgs, ... }:

{
  services.logind.settings.Login.HandlePowerKey = "ignore";

  home-manager.users.antoine =
    { config, ... }:
    let
      noctalia-shell = builtins.getFlake "github:noctalia-dev/noctalia-shell";
    in
    {
      imports = [
        noctalia-shell.homeModules.default
      ];

      home.packages = with pkgs; [
        kdePackages.dolphin
        xremap
        wtype
      ];

      xdg.configFile."xremap.yml".text = ''
        modmap:
          - name: Super-to-F20
            remap:
              Super_L:
                held: Super_L
                alone: F20
                free_hold: true
        keymap:
          - name: F20-to-Noctalia
            remap:
              F20:
                launch: ["noctalia-shell", "ipc", "call", "launcher", "toggle"]
      '';

      programs = {
        alacritty = {
          enable = true;
        };
        noctalia-shell = {
          enable = true;
          settings = ''
            {
              "settingsVersion": 59,
              "bar": {
                "barType": "simple",
                "position": "bottom",
                "monitors": [],
                "density": "default",
                "showOutline": false,
                "showCapsule": true,
                "capsuleOpacity": 1,
                "capsuleColorKey": "none",
                "widgetSpacing": 6,
                "contentPadding": 2,
                "fontScale": 1,
                "enableExclusionZoneInset": true,
                "backgroundOpacity": 0.93,
                "useSeparateOpacity": false,
                "marginVertical": 4,
                "marginHorizontal": 4,
                "frameThickness": 8,
                "frameRadius": 12,
                "outerCorners": true,
                "hideOnOverview": true,
                "displayMode": "always_visible",
                "autoHideDelay": 500,
                "autoShowDelay": 150,
                "showOnWorkspaceSwitch": true,
                "widgets": {
                  "left": [
                    {
                      "colorizeSystemIcon": "none",
                      "colorizeSystemText": "none",
                      "customIconPath": "",
                      "enableColorization": false,
                      "icon": "rocket",
                      "iconColor": "none",
                      "id": "Launcher",
                      "useDistroLogo": false
                    },
                    {
                      "compactMode": true,
                      "diskPath": "/",
                      "iconColor": "none",
                      "id": "SystemMonitor",
                      "showCpuCores": false,
                      "showCpuFreq": false,
                      "showCpuTemp": true,
                      "showCpuUsage": true,
                      "showDiskAvailable": false,
                      "showDiskUsage": false,
                      "showDiskUsageAsPercent": true,
                      "showGpuTemp": false,
                      "showLoadAverage": false,
                      "showMemoryAsPercent": true,
                      "showMemoryUsage": true,
                      "showNetworkStats": false,
                      "showSwapUsage": false,
                      "textColor": "none",
                      "useMonospaceFont": true,
                      "usePadding": false
                    }
                  ],
                  "center": [
                    {
                      "characterCount": 2,
                      "colorizeIcons": false,
                      "emptyColor": "secondary",
                      "enableScrollWheel": true,
                      "focusedColor": "primary",
                      "followFocusedScreen": false,
                      "fontWeight": "bold",
                      "groupedBorderOpacity": 1,
                      "hideUnoccupied": false,
                      "iconScale": 0.8,
                      "id": "Workspace",
                      "labelMode": "index",
                      "occupiedColor": "secondary",
                      "pillSize": 0.6,
                      "showApplications": false,
                      "showApplicationsHover": false,
                      "showBadge": true,
                      "showLabelsOnlyWhenOccupied": true,
                      "unfocusedIconsOpacity": 1
                    }
                  ],
                  "right": [
                    {
                      "blacklist": [],
                      "chevronColor": "none",
                      "colorizeIcons": false,
                      "drawerEnabled": false,
                      "hidePassive": false,
                      "id": "Tray",
                      "pinned": []
                    },
                    {
                      "displayMode": "onhover",
                      "iconColor": "none",
                      "id": "Network",
                      "textColor": "none"
                    },
                    {
                      "displayMode": "onhover",
                      "iconColor": "none",
                      "id": "Volume",
                      "middleClickCommand": "easyeffects",
                      "textColor": "none"
                    },
                    {
                      "deviceNativePath": "__default__",
                      "displayMode": "icon-hover",
                      "hideIfIdle": false,
                      "hideIfNotDetected": true,
                      "id": "Battery",
                      "showNoctaliaPerformance": true,
                      "showPowerProfiles": true
                    },
                    {
                      "clockColor": "none",
                      "customFont": "",
                      "formatHorizontal": "HH:mm",
                      "formatVertical": "HH mm - dd MM",
                      "id": "Clock",
                      "tooltipFormat": "dd/MM/yyyy",
                      "useCustomFont": false
                    },
                    {
                      "hideWhenZero": false,
                      "hideWhenZeroUnread": true,
                      "iconColor": "none",
                      "id": "NotificationHistory",
                      "showUnreadBadge": true,
                      "unreadBadgeColor": "primary"
                    },
                    {
                      "colorizeDistroLogo": false,
                      "colorizeSystemIcon": "none",
                      "colorizeSystemText": "none",
                      "customIconPath": "",
                      "enableColorization": true,
                      "icon": "adjustments",
                      "id": "ControlCenter",
                      "useDistroLogo": false
                    }
                  ]
                },
                "mouseWheelAction": "workspace",
                "reverseScroll": true,
                "mouseWheelWrap": false,
                "middleClickAction": "launcherPanel",
                "middleClickFollowMouse": false,
                "middleClickCommand": "",
                "rightClickAction": "controlCenter",
                "rightClickFollowMouse": true,
                "rightClickCommand": "",
                "screenOverrides": []
              },
              "general": {
                "avatarImage": "${config.home.homeDirectory}/.face",
                "dimmerOpacity": 0.2,
                "showScreenCorners": true,
                "forceBlackScreenCorners": true,
                "scaleRatio": 1,
                "radiusRatio": 1,
                "iRadiusRatio": 1,
                "boxRadiusRatio": 1,
                "screenRadiusRatio": 1,
                "animationSpeed": 1,
                "animationDisabled": false,
                "compactLockScreen": false,
                "lockScreenAnimations": true,
                "lockOnSuspend": true,
                "showSessionButtonsOnLockScreen": true,
                "showHibernateOnLockScreen": true,
                "enableLockScreenMediaControls": true,
                "enableShadows": true,
                "enableBlurBehind": true,
                "shadowDirection": "center",
                "shadowOffsetX": 0,
                "shadowOffsetY": 0,
                "language": "",
                "allowPanelsOnScreenWithoutBar": true,
                "showChangelogOnStartup": true,
                "telemetryEnabled": false,
                "enableLockScreenCountdown": true,
                "lockScreenCountdownDuration": 10000,
                "autoStartAuth": true,
                "allowPasswordWithFprintd": false,
                "clockStyle": "digital",
                "clockFormat": "hh\\nmm",
                "passwordChars": true,
                "lockScreenMonitors": [],
                "lockScreenBlur": 0.5,
                "lockScreenTint": 0,
                "keybinds": {
                  "keyUp": [
                    "Up"
                  ],
                  "keyDown": [
                    "Down"
                  ],
                  "keyLeft": [
                    "Left"
                  ],
                  "keyRight": [
                    "Right"
                  ],
                  "keyEnter": [
                    "Return",
                    "Enter"
                  ],
                  "keyEscape": [
                    "Esc"
                  ],
                  "keyRemove": [
                    "Del"
                  ]
                },
                "reverseScroll": false,
                "smoothScrollEnabled": true
              },
              "ui": {
                "fontDefault": "Sans Serif",
                "fontFixed": "monospace",
                "fontDefaultScale": 1,
                "fontFixedScale": 1,
                "tooltipsEnabled": true,
                "scrollbarAlwaysVisible": true,
                "boxBorderEnabled": false,
                "panelBackgroundOpacity": 0.93,
                "translucentWidgets": false,
                "panelsAttachedToBar": true,
                "settingsPanelMode": "attached",
                "settingsPanelSideBarCardStyle": false
              },
              "location": {
                "name": "",
                "weatherEnabled": true,
                "weatherShowEffects": true,
                "weatherTaliaMascotAlways": false,
                "useFahrenheit": false,
                "use12hourFormat": false,
                "showWeekNumberInCalendar": false,
                "showCalendarEvents": true,
                "showCalendarWeather": true,
                "analogClockInCalendar": false,
                "firstDayOfWeek": -1,
                "hideWeatherTimezone": true,
                "hideWeatherCityName": false,
                "autoLocate": true
              },
              "calendar": {
                "cards": [
                  {
                    "enabled": true,
                    "id": "calendar-header-card"
                  },
                  {
                    "enabled": true,
                    "id": "calendar-month-card"
                  },
                  {
                    "enabled": true,
                    "id": "weather-card"
                  }
                ]
              },
              "wallpaper": {
                "enabled": true,
                "overviewEnabled": false,
                "directory": "${config.home.homeDirectory}/Pictures/Wallpapers",
                "monitorDirectories": [],
                "enableMultiMonitorDirectories": false,
                "showHiddenFiles": false,
                "viewMode": "single",
                "setWallpaperOnAllMonitors": true,
                "linkLightAndDarkWallpapers": true,
                "fillMode": "crop",
                "fillColor": "#000000",
                "useSolidColor": false,
                "solidColor": "#1a1a2e",
                "automationEnabled": false,
                "wallpaperChangeMode": "random",
                "randomIntervalSec": 300,
                "transitionDuration": 1500,
                "transitionType": [
                  "disc"
                ],
                "skipStartupTransition": false,
                "transitionEdgeSmoothness": 0.05,
                "panelPosition": "follow_bar",
                "hideWallpaperFilenames": false,
                "useOriginalImages": false,
                "overviewBlur": 0.4,
                "overviewTint": 0.6,
                "useWallhaven": false,
                "wallhavenQuery": "",
                "wallhavenSorting": "relevance",
                "wallhavenOrder": "desc",
                "wallhavenCategories": "111",
                "wallhavenPurity": "100",
                "wallhavenRatios": "",
                "wallhavenApiKey": "",
                "wallhavenResolutionMode": "atleast",
                "wallhavenResolutionWidth": "",
                "wallhavenResolutionHeight": "",
                "sortOrder": "name",
                "favorites": []
              },
              "appLauncher": {
                "enableClipboardHistory": true,
                "autoPasteClipboard": true,
                "enableClipPreview": true,
                "clipboardWrapText": true,
                "enableClipboardSmartIcons": true,
                "enableClipboardChips": true,
                "clipboardWatchTextCommand": "wl-paste --type text --watch cliphist store",
                "clipboardWatchImageCommand": "wl-paste --type image --watch cliphist store",
                "position": "center",
                "pinnedApps": [],
                "sortByMostUsed": true,
                "terminalCommand": "alacritty -e",
                "customLaunchPrefixEnabled": false,
                "customLaunchPrefix": "",
                "viewMode": "list",
                "showCategories": true,
                "iconMode": "tabler",
                "showIconBackground": true,
                "enableSettingsSearch": true,
                "enableWindowsSearch": true,
                "enableSessionSearch": true,
                "ignoreMouseInput": false,
                "screenshotAnnotationTool": "",
                "overviewLayer": false,
                "density": "default"
              },
              "controlCenter": {
                "position": "close_to_bar_button",
                "diskPath": "/",
                "shortcuts": {
                  "left": [
                    {
                      "id": "Network"
                    },
                    {
                      "id": "Bluetooth"
                    },
                    {
                      "id": "WallpaperSelector"
                    },
                    {
                      "id": "NoctaliaPerformance"
                    }
                  ],
                  "right": [
                    {
                      "id": "Notifications"
                    },
                    {
                      "id": "PowerProfile"
                    },
                    {
                      "id": "KeepAwake"
                    },
                    {
                      "id": "NightLight"
                    }
                  ]
                },
                "cards": [
                  {
                    "enabled": true,
                    "id": "profile-card"
                  },
                  {
                    "enabled": true,
                    "id": "shortcuts-card"
                  },
                  {
                    "enabled": true,
                    "id": "brightness-card"
                  },
                  {
                    "enabled": true,
                    "id": "audio-card"
                  },
                  {
                    "enabled": false,
                    "id": "weather-card"
                  },
                  {
                    "enabled": true,
                    "id": "media-sysmon-card"
                  }
                ]
              },
              "systemMonitor": {
                "cpuWarningThreshold": 80,
                "cpuCriticalThreshold": 90,
                "tempWarningThreshold": 80,
                "tempCriticalThreshold": 90,
                "gpuWarningThreshold": 80,
                "gpuCriticalThreshold": 90,
                "memWarningThreshold": 80,
                "memCriticalThreshold": 90,
                "swapWarningThreshold": 80,
                "swapCriticalThreshold": 90,
                "diskWarningThreshold": 80,
                "diskCriticalThreshold": 90,
                "diskAvailWarningThreshold": 20,
                "diskAvailCriticalThreshold": 10,
                "batteryWarningThreshold": 20,
                "batteryCriticalThreshold": 5,
                "enableDgpuMonitoring": false,
                "useCustomColors": false,
                "warningColor": "#b9c6ea",
                "criticalColor": "#ffb4ab",
                "externalMonitor": "resources || missioncenter || jdsystemmonitor || corestats || system-monitoring-center || gnome-system-monitor || plasma-systemmonitor || mate-system-monitor || ukui-system-monitor || deepin-system-monitor || pantheon-system-monitor"
              },
              "noctaliaPerformance": {
                "disableWallpaper": true,
                "disableDesktopWidgets": true
              },
              "dock": {
                "enabled": true,
                "position": "bottom",
                "displayMode": "auto_hide",
                "dockType": "attached",
                "backgroundOpacity": 1,
                "floatingRatio": 1,
                "size": 1,
                "onlySameOutput": true,
                "monitors": [],
                "pinnedApps": [],
                "colorizeIcons": false,
                "showLauncherIcon": false,
                "launcherPosition": "end",
                "launcherUseDistroLogo": false,
                "launcherIcon": "",
                "launcherIconColor": "none",
                "pinnedStatic": false,
                "inactiveIndicators": false,
                "groupApps": false,
                "groupContextMenuMode": "extended",
                "groupClickAction": "cycle",
                "groupIndicatorStyle": "dots",
                "deadOpacity": 0.6,
                "animationSpeed": 1,
                "sitOnFrame": false,
                "showDockIndicator": false,
                "indicatorThickness": 3,
                "indicatorColor": "primary",
                "indicatorOpacity": 0.6
              },
              "network": {
                "bluetoothRssiPollingEnabled": false,
                "bluetoothRssiPollIntervalMs": 60000,
                "networkPanelView": "wifi",
                "wifiDetailsViewMode": "grid",
                "bluetoothDetailsViewMode": "grid",
                "bluetoothHideUnnamedDevices": false,
                "disableDiscoverability": true,
                "bluetoothAutoConnect": true
              },
              "sessionMenu": {
                "enableCountdown": true,
                "countdownDuration": 10000,
                "position": "center",
                "showHeader": false,
                "showKeybinds": true,
                "largeButtonsStyle": false,
                "largeButtonsLayout": "grid",
                "powerOptions": [
                  {
                    "action": "lock",
                    "command": "",
                    "countdownEnabled": true,
                    "enabled": true,
                    "keybind": "1"
                  },
                  {
                    "action": "suspend",
                    "command": "",
                    "countdownEnabled": true,
                    "enabled": true,
                    "keybind": "2"
                  },
                  {
                    "action": "hibernate",
                    "command": "",
                    "countdownEnabled": true,
                    "enabled": true,
                    "keybind": "3"
                  },
                  {
                    "action": "reboot",
                    "command": "",
                    "countdownEnabled": true,
                    "enabled": true,
                    "keybind": "4"
                  },
                  {
                    "action": "logout",
                    "command": "",
                    "countdownEnabled": true,
                    "enabled": true,
                    "keybind": "5"
                  },
                  {
                    "action": "shutdown",
                    "command": "",
                    "countdownEnabled": true,
                    "enabled": true,
                    "keybind": "6"
                  },
                  {
                    "action": "rebootToUefi",
                    "command": "",
                    "countdownEnabled": true,
                    "enabled": true,
                    "keybind": "7"
                  },
                  {
                    "action": "userspaceReboot",
                    "command": "",
                    "countdownEnabled": true,
                    "enabled": true,
                    "keybind": "8"
                  }
                ]
              },
              "notifications": {
                "enabled": true,
                "enableMarkdown": true,
                "density": "default",
                "monitors": [],
                "location": "top_right",
                "overlayLayer": true,
                "backgroundOpacity": 1,
                "respectExpireTimeout": false,
                "lowUrgencyDuration": 3,
                "normalUrgencyDuration": 8,
                "criticalUrgencyDuration": 15,
                "clearDismissed": true,
                "saveToHistory": {
                  "low": true,
                  "normal": true,
                  "critical": true
                },
                "sounds": {
                  "enabled": true,
                  "volume": 0.5,
                  "separateSounds": false,
                  "criticalSoundFile": "",
                  "normalSoundFile": "",
                  "lowSoundFile": "",
                  "excludedApps": "discord,firefox,chrome,chromium,edge"
                },
                "enableMediaToast": true,
                "enableKeyboardLayoutToast": true,
                "enableBatteryToast": true
              },
              "osd": {
                "enabled": true,
                "location": "top_right",
                "autoHideMs": 2000,
                "overlayLayer": true,
                "backgroundOpacity": 1,
                "enabledTypes": [
                  0,
                  1,
                  2,
                  3
                ],
                "monitors": []
              },
              "audio": {
                "volumeStep": 5,
                "volumeOverdrive": false,
                "spectrumFrameRate": 30,
                "visualizerType": "linear",
                "spectrumMirrored": true,
                "mprisBlacklist": [],
                "preferredPlayer": "",
                "volumeFeedback": false,
                "volumeFeedbackSoundFile": ""
              },
              "brightness": {
                "brightnessStep": 5,
                "enforceMinimum": true,
                "enableDdcSupport": true,
                "backlightDeviceMappings": []
              },
              "colorSchemes": {
                "useWallpaperColors": true,
                "predefinedScheme": "Noctalia (default)",
                "darkMode": true,
                "schedulingMode": "location",
                "manualSunrise": "06:30",
                "manualSunset": "18:30",
                "generationMethod": "tonal-spot",
                "monitorForColors": "",
                "syncGsettings": true
              },
              "templates": {
                "activeTemplates": [
                  {
                    "enabled": true,
                    "id": "alacritty"
                  }
                ],
                "enableUserTheming": false
              },
              "nightLight": {
                "enabled": false,
                "forced": false,
                "autoSchedule": true,
                "nightTemp": "4000",
                "dayTemp": "6500",
                "manualSunrise": "06:30",
                "manualSunset": "18:30"
              },
              "hooks": {
                "enabled": false,
                "wallpaperChange": "",
                "darkModeChange": "",
                "screenLock": "",
                "screenUnlock": "",
                "performanceModeEnabled": "",
                "performanceModeDisabled": "",
                "startup": "",
                "session": "",
                "colorGeneration": ""
              },
              "plugins": {
                "autoUpdate": false,
                "notifyUpdates": true
              },
              "idle": {
                "enabled": true,
                "screenOffTimeout": 600,
                "lockTimeout": 605,
                "suspendTimeout": 900,
                "fadeDuration": 5,
                "screenOffCommand": "",
                "lockCommand": "",
                "suspendCommand": "",
                "resumeScreenOffCommand": "",
                "resumeLockCommand": "",
                "resumeSuspendCommand": "",
                "customCommands": "[]"
              },
              "desktopWidgets": {
                "enabled": false,
                "overviewEnabled": true,
                "gridSnap": true,
                "gridSnapScale": true,
                "monitorWidgets": []
              }
            }
          '';
        };
      };
    };
}
