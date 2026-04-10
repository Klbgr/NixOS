{ ... }:

{
  home-manager.users.antoine =
    { config, pkgs, ... }:

    {
      home.pointerCursor = {
        name = "Bibata-Modern-Classic";
        package = pkgs.bibata-cursors;
        gtk.enable = true;
        x11.enable = true;
      };

      xdg.configFile."niri/config.kdl".text = ''
        input {
            touchpad {
                tap
                drag true
                drag-lock
                natural-scroll
            }
            mouse {
                // natural-scroll
                // accel-speed 0.2
                // accel-profile "flat"
                // scroll-method "no-scroll"
            }
            focus-follows-mouse max-scroll-amount="0%"
            disable-power-key-handling
        }
        gestures {
          hot-corners {
            off
          }
        }
        output "Toshiba America Info Systems Inc ScreenXpert- 0x88888800" {
            off
        }
        layout {
            gaps 16
            center-focused-column "never"
            always-center-single-column
            default-column-display "normal"
            background-color "#000000"
            preset-column-widths {
                proportion 0.33333
                proportion 0.5
                proportion 0.66667
            }
            default-column-width { proportion 0.5; }
            preset-window-heights {
                proportion 0.33333
                proportion 0.5
                proportion 0.66667
            }
            focus-ring {
                width 2
                active-color "#FFFFFF7F"
                inactive-color "#00000000"
            }
            shadow {
                on
                softness 30
                spread 5
                offset x=0 y=0
                color "#0007"
            }
        }
        prefer-no-csd
        spawn-sh-at-startup "noctalia-shell -d && noctalia-shell ipc call lockScreen lock"
        spawn-sh-at-startup "xwayland-satellite"
        spawn-sh-at-startup "xremap ${config.home.homeDirectory}/.config/xremap.yml"
        hotkey-overlay {
            skip-at-startup
        }
        screenshot-path "${config.home.homeDirectory}/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png"
        window-rule {
            match title="(?i)picture.in.picture"
            default-column-width { proportion 0.25; }
            default-window-height { proportion 0.25; }
            open-floating true
            default-floating-position x=16 y=16 relative-to="bottom-right"
        }
        window-rule {
            geometry-corner-radius 12
            clip-to-geometry true
        } 
        binds {
            Mod+Tab allow-when-locked=true { spawn-sh "cycle-output"; }
            Mod+L { spawn-sh "noctalia-shell ipc call lockScreen lock"; }
            XF86PowerOff allow-when-locked=true { spawn-sh "noctalia-shell ipc call sessionMenu toggle"; }
            Mod+V { spawn-sh "noctalia-shell ipc call launcher clipboard"; }
            Mod+C { spawn "gemini"; }

            Mod+Shift+Colon { show-hotkey-overlay; }
            Mod+T hotkey-overlay-title="Open a Terminal: alacritty" { spawn "alacritty"; }
            Mod+O repeat=false { toggle-overview; }
            Mod+Q repeat=false { close-window; }

            XF86AudioRaiseVolume allow-when-locked=true { spawn-sh "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.05+ -l 1.0"; }
            XF86AudioLowerVolume allow-when-locked=true { spawn-sh "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.05-"; }
            XF86AudioMute        allow-when-locked=true { spawn-sh "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"; }
            XF86AudioMicMute     allow-when-locked=true { spawn-sh "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"; }
            XF86AudioPlay        allow-when-locked=true { spawn-sh "playerctl play-pause"; }
            XF86AudioStop        allow-when-locked=true { spawn-sh "playerctl stop"; }
            XF86AudioPrev        allow-when-locked=true { spawn-sh "playerctl previous"; }
            XF86AudioNext        allow-when-locked=true { spawn-sh "playerctl next"; }

            XF86MonBrightnessUp allow-when-locked=true { spawn "brightnessctl" "--class=backlight" "set" "+5%"; }
            XF86MonBrightnessDown allow-when-locked=true { spawn "brightnessctl" "--class=backlight" "set" "5%-"; }

            Mod+Left  { focus-column-left; }
            Mod+Down  { focus-window-or-workspace-down; }
            Mod+Up    { focus-window-or-workspace-up; }
            Mod+Right { focus-column-right; }

            Mod+Ctrl+Left  { move-column-left; }
            Mod+Ctrl+Down  { move-window-down-or-to-workspace-down; }
            Mod+Ctrl+Up    { move-window-up-or-to-workspace-up; }
            Mod+Ctrl+Right { move-column-right; }

            Mod+Home { focus-column-first; }
            Mod+End  { focus-column-last; }
            Mod+Ctrl+Home { move-column-to-first; }
            Mod+Ctrl+End  { move-column-to-last; }

            Mod+Shift+Left  { focus-monitor-left; }
            Mod+Shift+Down  { focus-monitor-down; }
            Mod+Shift+Up    { focus-monitor-up; }
            Mod+Shift+Right { focus-monitor-right; }

            Mod+Shift+Ctrl+Left  { move-column-to-monitor-left; }
            Mod+Shift+Ctrl+Down  { move-column-to-monitor-down; }
            Mod+Shift+Ctrl+Up    { move-column-to-monitor-up; }
            Mod+Shift+Ctrl+Right { move-column-to-monitor-right; }

            Mod+Alt+Down { move-workspace-down; }
            Mod+Alt+Up   { move-workspace-up; }
            Mod+Alt+Left  { move-workspace-to-monitor-left; }
            Mod+Alt+Right { move-workspace-to-monitor-right; }

            Mod+WheelScrollDown      cooldown-ms=150 { focus-window-or-workspace-down; }
            Mod+WheelScrollUp        cooldown-ms=150 { focus-window-or-workspace-up; }
            Mod+Ctrl+WheelScrollDown cooldown-ms=150 { move-window-down-or-to-workspace-down; }
            Mod+Ctrl+WheelScrollUp   cooldown-ms=150 { move-window-up-or-to-workspace-up; }

            Mod+WheelScrollRight      { focus-column-right; }
            Mod+WheelScrollLeft       { focus-column-left; }
            Mod+Ctrl+WheelScrollRight { move-column-right; }
            Mod+Ctrl+WheelScrollLeft  { move-column-left; }

            Mod+Shift+WheelScrollDown      { focus-column-right; }
            Mod+Shift+WheelScrollUp        { focus-column-left; }
            Mod+Ctrl+Shift+WheelScrollDown { move-column-right; }
            Mod+Ctrl+Shift+WheelScrollUp   { move-column-left; }

            Mod+Alt+WheelScrollDown { move-workspace-down; }
            Mod+Alt+WheelScrollUp   { move-workspace-up; }
            Mod+Alt+WheelScrollLeft  { move-workspace-to-monitor-left; }
            Mod+Alt+WheelScrollRight { move-workspace-to-monitor-right; }

            Mod+Alt+Tab { focus-workspace-previous; }

            Mod+R { switch-preset-column-width; }
            Mod+Shift+R { switch-preset-window-height; }
            Mod+Ctrl+R { reset-window-height; }
            Mod+F { maximize-column; }
            Mod+Shift+F { maximize-window-to-edges; }
            Mod+Shift+Control+F { fullscreen-window; }

            Mod+Shift+C { center-column; }
            Mod+Ctrl+Shift+C { center-visible-columns; }

            Mod+Minus { set-column-width "-10%"; }
            Mod+Equal { set-column-width "+10%"; }

            Mod+Shift+Minus { set-window-height "-10%"; }
            Mod+Shift+Equal { set-window-height "+10%"; }

            Mod+Shift+V       { toggle-window-floating; }
            Mod+Control+Shift+V { switch-focus-between-floating-and-tiling; }

            Print { screenshot; }
            Ctrl+Print { screenshot-screen; }
            Alt+Print { screenshot-window; }
            Mod+Shift+S { screenshot; }

            Mod+Escape allow-inhibiting=false { toggle-keyboard-shortcuts-inhibit; }
        }
      '';
    };
}
