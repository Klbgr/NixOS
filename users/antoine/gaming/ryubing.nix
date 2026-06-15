{ ... }:

{
  home-manager.users.antoine =
    { pkgs, lib, ... }:

    {
      home.packages = with pkgs; [
        (symlinkJoin {
          name = "ryujinx-with-gamemoderun-mangohud";
          paths = [
            (writeShellScriptBin "ryujinx" ''
              exec ${gamemode}/bin/gamemoderun ${mangohud}/bin/mangohud ${ryubing}/bin/ryujinx "$@"
            '')
            ryubing
          ];
        })
      ];

      home.activation.mergeRyujinxConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        PATCHER="${pkgs.configuration-patcher}/bin/configuration-patcher"

        CONFIG_FILE="$HOME/.config/Ryujinx/Config.json"

        $PATCHER json "$CONFIG_FILE" '{
          "start_fullscreen": true,
          "start_no_ui": false,
          "language_code": "fr_FR",

          "show_confirm_exit": true,
          "remember_window_state": true,
          "enable_discord_integration": true,
          "focus_lost_action_type": "DoNothing",
          "update_checker_type": "Off",
          "hide_cursor": 1,
          "base_style": "Dark",
          "game_dirs": [
            "/games/Switch"
          ],
          "autoload_dirs": [
            "/games/Switch/DLC"
          ],

          "system_region": "Europe",
          "system_language": "French",
          "system_time_zone": "UTC",
          "match_system_time": true,
          "vsync_mode": 0,
          "custom_vsync_interval": 120,
          "enable_fs_integrity_checks": true,
          "dram_size": 0,
          "ignore_missing_services": false,
          "enable_custom_vsync_interval": false,
          "skip_user_profiles": false,

          "enable_ptc": true,
          "enable_low_power_ptc": false,
          "memory_manager_mode": "HostMappedUnsafe",
          "tick_scalar": 50,

          "graphics_backend": "Vulkan",
          "backend_threading": "Auto",
          "enable_shader_cache": true,
          "enable_texture_recompression": false,
          "enable_macro_hle": true,
          "anti_aliasing": "SmaaUltra",
          "scaling_filter": "Fsr",
          "scaling_filter_level": 75,
          "max_anisotropy": 16,
          "aspect_ratio": "Fixed16x9",
          "graphics_shaders_dump_path": "",

          "audio_backend": "SDL2",
          "audio_volume": 1,

          "hotkeys": {
            "toggle_vsync_mode": "F1",
            "screenshot": "F8",
            "show_ui": "F4",
            "pause": "F5",
            "toggle_mute": "F2",
            "res_scale_up": "Unbound",
            "res_scale_down": "Unbound",
            "volume_up": "Unbound",
            "volume_down": "Unbound",
            "custom_vsync_interval_increment": "Unbound",
            "custom_vsync_interval_decrement": "Unbound",
            "turbo_mode": "Unbound",
            "turbo_mode_while_held": false
          },

          "multiplayer_mode": 0,
          "multiplayer_disable_p2p": false,

          "enable_file_log": true,
          "logging_enable_stub": true,
          "logging_enable_info": true,
          "logging_enable_warn": true,
          "logging_enable_error": true,
          "logging_enable_guest": true,
          "logging_enable_trace": false,
          "logging_enable_fs_access_log": false,
          "logging_enable_debug": false,
          "logging_enable_avalonia": false,
          "fs_global_access_log_mode": 0,
          "logging_graphics_debug_level": "None",

          "enable_gdb_stub": false,
          "gdb_stub_port": 55555,
          "debugger_suspend_on_start": false,

          "shown_file_types": {
              "nsp": true,
              "pfs0": true,
              "xci": true,
              "nca": true,
              "nro": true,
              "nso": true
          }
        }'
      '';
    };
}
