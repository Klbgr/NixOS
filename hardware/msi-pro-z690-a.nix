{ config, lib, ... }:

{
  imports = [
    ./modules/intel-cpu.nix
    ./modules/nvidia-gpu.nix
    ./modules/fan.nix
    ./modules/led.nix
  ];

  networking.hostName = "MSI-PRO-Z690-A";
  boot.kernelModules = [ "nct6687" ];
  boot.extraModulePackages = with config.boot.kernelPackages; [
    nct6687d
  ];

  swapDevices = lib.mkForce [
    {
      device = "/var/lib/swapfile";
      size = 48 * 1024;
      priority = 0;
    }
  ];

  fileSystems."/games" = {
    device = "/dev/disk/by-label/games";
    fsType = "ext4";
  };

  systemd.tmpfiles.rules = [
    "d /games 0775 root users -"
  ];

  environment.etc."lact/config.yaml".text = ''
    version: 5
    daemon:
      log_level: info
      admin_group: wheel
      disable_clocks_cleanup: false
    apply_settings_timer: 5
    gpus:
      10DE:2488-1458:404C-0000:01:00.0:
        fan_control_enabled: false
        power_cap: 270.0
    profiles:
      Undervolt:
        gpus:
          10DE:2488-1458:404C-0000:01:00.0:
            fan_control_enabled: false
            power_cap: 270.0
            min_core_clock: 210
            max_core_clock: 1900
            gpu_clock_offsets:
              0: 200
            mem_clock_offsets:
              0: 2800
    current_profile: Undervolt
    auto_switch_profiles: false
  '';

  environment.etc."coolercontrol/config.toml" = {
    text = ''
      # This is the CoolerControl configuration file.
      # Comments and most formatting is preserved.
      # Most of this file you can edit by hand, but it is recommended to stop the daemon when doing so.
      # -------------------------------


      # Unique ID Device List
      # -------------------------------
      # This is a simple UID and device name key-value pair, that is automatically generated at startup
      #  to help humans distinguish which UID belongs to which device in this config file.
      #  Only the device name is given here, complete Device information can be requested from the API.
      #  UIDs are generated sha256 hashes based on specific criteria to help determine device uniqueness.
      # ANY CHANGES WILL BE OVERWRITTEN.
      # Example:
      # 21091c4fb341ceab6236e8c9e905ccc263a4ac08134b036ed415925ba4c1645d = "Nvidia GPU"
      [devices]
      c34fecca5757e17ac005b293d2fe7515e6da0ca72e18037ea0939bf2d26554be = "12th Gen Intel(R) Core(TM) i9-12900K"
      4b9cd1bc5fb2921253e6b7dd5b1b011086ea529d915a86b3560c236084452807 = "NZXT Kraken X (X53, X63 or X73)"
      f42333b13a2853dfb8e516c576470622e74a4659bfffe7ca229f68733beae979 = "acpitz"
      3d56d0d9753fcbe48edbccc5b323b1eb63a466a7b9a703574773906edb9fd159 = "NVIDIA GeForce RTX 3070"
      05c2c2d0c40387973a7ecd97d789f061b652f39d10714f0c2599f8a3bd645303 = "nvme"
      19e098e312e1b1b39163a343ea22b6ea17f18ec1a803ffe0ce44f5bacd6076ee = "Custom Sensors"
      33f022b13ddcf5eef2951eec6ee8e408eabdf92b3ae22bbc7d2c06decea183cb = "iwlwifi_1"
      524778e4a6e810a8814e6cf90367bc8d5f8faf67bb9e44758f6219d9ea5d76cf = "iwlwifi_1"
      7bfee7e15e0af819a1c74ac2f088d69197bdae5f361d2af4da2960c931be3cc7 = "nct6687"
      8620f7a6277716ec568f8a7de66471129041f6096cc18e8d82b75226a688b081 = "nvme"
      f8a50e66819260384cb74fb32f2d291efe439d369d8598bdd0a0a84751341cfd = "x53"


      # Legacy690 Option for devices
      # -------------------------------
      # There are 2 Asetek 690LC liquid coolers that have the same device ID.
      #  To tell them apart we need user input to know which cooler we're actually dealing with.
      #  This is an assignment of liquidctl AseTek690LC device UIDs to true/false:
      #   true = Legacy690 Cooler aka NZXT Kraken X40, X60, X31, X41, X51 and X61
      #   false = Modern690 Cooler aka EVGA CLC 120 (CLC12), 240, 280 and 360
      # Example:
      # 21091c4fb341ceab6236e8c9e905ccc263a4ac08134b036ed415925ba4c1645d = true
      [legacy690]


      # Device Settings
      # -------------------------------
      # This is where CoolerControl will save device settings for the cooresponding device.
      # Settings can be set here also specifically by hand. (restart required for applying)
      # These settings are applied on startup and each is overwritten once a new setting
      # has been applied.
      # Example:
      # [device-settings.4b9cd1bc5fb2921253e6b7dd5b1b011086ea529d915a86b3560c236084452807]
      # pump = { speed_fixed = 30 }
      # logo = { lighting = { mode = "fixed", colors = [[0, 255, 255]] } }
      # ring = { lighting = { mode = "spectrum-wave", backward = true, colors = [] } }
      [device-settings]

      [device-settings.3d56d0d9753fcbe48edbccc5b323b1eb63a466a7b9a703574773906edb9fd159]
      fan1 = { profile_uid = "e2b22311-4f2c-4c6b-9ee6-d0ba1873496e" }
      fan2 = { profile_uid = "e2b22311-4f2c-4c6b-9ee6-d0ba1873496e" }

      [device-settings.7bfee7e15e0af819a1c74ac2f088d69197bdae5f361d2af4da2960c931be3cc7]
      fan1 = { profile_uid = "69627b9d-b7ac-4291-8d53-e81d17d69f89" }
      fan3 = { profile_uid = "69627b9d-b7ac-4291-8d53-e81d17d69f89" }
      fan4 = { profile_uid = "69627b9d-b7ac-4291-8d53-e81d17d69f89" }

      [device-settings.4b9cd1bc5fb2921253e6b7dd5b1b011086ea529d915a86b3560c236084452807]
      pump = { profile_uid = "5fc29cf7-4a7d-4324-94d9-ea2846584d19" }


      # A list of profiles to be used with each device's settings
      # -------------------------------
      [[profiles]]
      uid = "0"
      name = "Default Profile"
      p_type = "Default"
      function = "0"

      [[profiles]]
      uid = "5fc29cf7-4a7d-4324-94d9-ea2846584d19"
      name = "Pump"
      p_type = "Graph"
      speed_profile = [[0.0, 70], [40.0, 70], [60.0, 100], [100.0, 100]]
      temp_source = { temp_name = "temp1", device_uid = "7bfee7e15e0af819a1c74ac2f088d69197bdae5f361d2af4da2960c931be3cc7" }
      temp_min = 0.0
      temp_max = 100.0
      function_uid = "0"
      offset_profile = []

      [[profiles]]
      uid = "e2b22311-4f2c-4c6b-9ee6-d0ba1873496e"
      name = "GPU"
      p_type = "Graph"
      speed_profile = [[0.0, 0], [50.0, 0], [80.0, 100], [100.0, 100]]
      temp_source = { temp_name = "GPU Temp", device_uid = "3d56d0d9753fcbe48edbccc5b323b1eb63a466a7b9a703574773906edb9fd159" }
      temp_min = 0.0
      temp_max = 100.0
      function_uid = "0"
      offset_profile = []

      [[profiles]]
      uid = "5bec4352-e2be-454c-85cc-0839b6226198"
      name = "CPU"
      p_type = "Graph"
      speed_profile = [[0.0, 30], [50.0, 30], [80.0, 100], [100.0, 100]]
      temp_source = { temp_name = "temp1", device_uid = "7bfee7e15e0af819a1c74ac2f088d69197bdae5f361d2af4da2960c931be3cc7" }
      temp_min = 0.0
      temp_max = 100.0
      function_uid = "0"
      offset_profile = []

      [[profiles]]
      uid = "69627b9d-b7ac-4291-8d53-e81d17d69f89"
      name = "Mix"
      p_type = "Mix"
      speed_profile = []
      function_uid = "0"
      member_profile_uids = ["e2b22311-4f2c-4c6b-9ee6-d0ba1873496e", "5bec4352-e2be-454c-85cc-0839b6226198"]
      mix_function_type = "Max"
      offset_profile = []

      # A list of functions to be applied to the various profiles
      # -------------------------------
      [[functions]]
      uid = "0"
      name = "Default Function"
      f_type = "Identity"


      # Cooler Control Settings
      # -------------------------------
      # This is where CoolerControl specifc general and specifc device settings are set. These device
      # settings differ from the above Device Settings, in that they are applied to CoolerControl,
      # and not on the devices themselves. For ex. settings such as disabling/enabling a particular device.
      [settings]

      # whether to apply the saved device settings on daemon startup
      apply_on_boot = true

      # Will skip initialization calls for liquidctl devices. ONLY USE if you are doing initialiation manually.
      no_init = false

      # Handle dynamic temp sources like cpu and gpu with a moving average rather than immediately up and down.
      handle_dynamic_temps = false

      # Startup Delay (seconds) is an integer value between 0 and 10
      startup_delay = 2

      # Smoothing level (averaging) for temp and load values of CPU and GPU devices. (0-5)
      # This only affects the returned values from the /status endpoint, not internal values
      smoothing_level = 0

      # For ThinkPads, wheather to use the 'full-speed' option when settings the fan to 100%
      # This option drives the fan as fast as it can go, which might exceed hardware limits,
      # so use this level with caution.
      thinkpad_full_speed = false

      # There are some devices that are supported both by liquidctl and hwmon drivers. Normally the
      # preference is to use liquidctl as it supports more features such as RGB control. There are
      # some cases where the hwmon driver is preferred though. Note: Care should be taken to blacklist
      # one of the devices to avoid needlessly loading the device IO and avoid concurrency issues.
      # Use at your own risk.
      hide_duplicate_devices = true

      [settings.c34fecca5757e17ac005b293d2fe7515e6da0ca72e18037ea0939bf2d26554be]
      name = "12th Gen Intel(R) Core(TM) i9-12900K"
      disable = true

      [settings.c34fecca5757e17ac005b293d2fe7515e6da0ca72e18037ea0939bf2d26554be.channel_settings]

      [settings.3d56d0d9753fcbe48edbccc5b323b1eb63a466a7b9a703574773906edb9fd159]
      name = "NVIDIA GeForce RTX 3070"
      disable = false

      [settings.3d56d0d9753fcbe48edbccc5b323b1eb63a466a7b9a703574773906edb9fd159.channel_settings]
      freq_memory = { label = "GPU Freq Memory", disabled = true }
      freq_video = { label = "GPU Freq Video", disabled = true }
      "GPU Power" = { label = "GPU Power", disabled = true }
      "GPU Load" = { label = "GPU Load", disabled = true }
      freq_graphics = { label = "GPU Freq Graphics", disabled = true }
      freq_sm = { label = "GPU Freq SM", disabled = true }

      [settings.4b9cd1bc5fb2921253e6b7dd5b1b011086ea529d915a86b3560c236084452807]
      name = "NZXT Kraken X"
      disable = false

      [settings.4b9cd1bc5fb2921253e6b7dd5b1b011086ea529d915a86b3560c236084452807.channel_settings]
      ring = { label = "Ring", disabled = true }
      sync = { label = "Sync", disabled = true }
      logo = { label = "Logo", disabled = true }
      liquid = { label = "Liquid", disabled = true }
      external = { label = "External", disabled = true }

      [settings.f42333b13a2853dfb8e516c576470622e74a4659bfffe7ca229f68733beae979]
      name = "acpitz"
      disable = true

      [settings.f42333b13a2853dfb8e516c576470622e74a4659bfffe7ca229f68733beae979.channel_settings]

      [settings.33f022b13ddcf5eef2951eec6ee8e408eabdf92b3ae22bbc7d2c06decea183cb]
      name = "iwlwifi_1"
      disable = true

      [settings.33f022b13ddcf5eef2951eec6ee8e408eabdf92b3ae22bbc7d2c06decea183cb.channel_settings]

      [settings.7bfee7e15e0af819a1c74ac2f088d69197bdae5f361d2af4da2960c931be3cc7]
      name = "nct6687"
      disable = false

      [settings.7bfee7e15e0af819a1c74ac2f088d69197bdae5f361d2af4da2960c931be3cc7.channel_settings]
      fan6 = { label = "System Fan #4", disabled = true }
      fan2 = { label = "Pump Fan", disabled = true }
      fan8 = { label = "System Fan #6", disabled = true }
      fan5 = { label = "System Fan #3", disabled = true }
      temp3 = { label = "Vrm Mos", disabled = true }
      temp2 = { label = "System", disabled = true }
      temp5 = { label = "Cpu Socket", disabled = true }
      fan7 = { label = "System Fan #5", disabled = true }
      temp7 = { label = "M2 1", disabled = true }
      temp4 = { label = "Pch", disabled = true }
      temp6 = { label = "Pc Ie X1", disabled = true }

      [settings.05c2c2d0c40387973a7ecd97d789f061b652f39d10714f0c2599f8a3bd645303]
      name = "Samsung SSD 970 EVO Plus 500GB"
      disable = true

      [settings.05c2c2d0c40387973a7ecd97d789f061b652f39d10714f0c2599f8a3bd645303.channel_settings]

      [settings.f8a50e66819260384cb74fb32f2d291efe439d369d8598bdd0a0a84751341cfd]
      name = "x53"
      disable = false

      [settings.f8a50e66819260384cb74fb32f2d291efe439d369d8598bdd0a0a84751341cfd.channel_settings]

      # CoolerControl Device settings Example:
      # [settings.4b9cd1bc5fb2921253e6b7dd5b1b011086ea529d915a86b3560c236084452807]
      # disabled = true

      # API Address and Port:
      # The daemon by default uses port 11987 and the standard loopback IPv4 and IPv6 addresses.
      # You can set an IPv4, IPv6 or both addresses to listen on. An empty string will disable the address.
      # It is highly recommended to use the default settings unless you have a specific reason to change them
      # and understand the implications. The API is not secure and should not be exposed to a public network.
      # For more information see the project wiki.
      # Example:
      # port = 11987
      # ipv4_address = "127.0.0.1"
      # ipv6_address = "::1"
    '';
    mode = "0644";
  };

  environment.etc."coolercontrol/modes.json" = {
    text = ''
      {
        "modes":[
            {
              "uid":"ef625307-76be-4b07-a4d4-18905be08051",
              "name":"Normal",
              "all_device_settings":{
                  "3d56d0d9753fcbe48edbccc5b323b1eb63a466a7b9a703574773906edb9fd159":{
                    "fan1":{
                        "channel_name":"fan1",
                        "speed_fixed":null,
                        "lighting":null,
                        "lcd":null,
                        "reset_to_default":null,
                        "profile_uid":"e2b22311-4f2c-4c6b-9ee6-d0ba1873496e"
                    },
                    "fan2":{
                        "channel_name":"fan2",
                        "speed_fixed":null,
                        "lighting":null,
                        "lcd":null,
                        "reset_to_default":null,
                        "profile_uid":"e2b22311-4f2c-4c6b-9ee6-d0ba1873496e"
                    }
                  },
                  "7bfee7e15e0af819a1c74ac2f088d69197bdae5f361d2af4da2960c931be3cc7":{
                    "fan1":{
                        "channel_name":"fan1",
                        "speed_fixed":null,
                        "lighting":null,
                        "lcd":null,
                        "reset_to_default":null,
                        "profile_uid":"69627b9d-b7ac-4291-8d53-e81d17d69f89"
                    },
                    "fan4":{
                        "channel_name":"fan4",
                        "speed_fixed":null,
                        "lighting":null,
                        "lcd":null,
                        "reset_to_default":null,
                        "profile_uid":"69627b9d-b7ac-4291-8d53-e81d17d69f89"
                    },
                    "fan3":{
                        "channel_name":"fan3",
                        "speed_fixed":null,
                        "lighting":null,
                        "lcd":null,
                        "reset_to_default":null,
                        "profile_uid":"69627b9d-b7ac-4291-8d53-e81d17d69f89"
                    }
                  },
                  "4b9cd1bc5fb2921253e6b7dd5b1b011086ea529d915a86b3560c236084452807":{
                    "pump":{
                        "channel_name":"pump",
                        "speed_fixed":null,
                        "lighting":null,
                        "lcd":null,
                        "reset_to_default":null,
                        "profile_uid":"5fc29cf7-4a7d-4324-94d9-ea2846584d19"
                    }
                  }
              }
            },
            {
              "uid":"d8d9832b-cc00-43dc-8f9b-221551c5fd8d",
              "name":"Max",
              "all_device_settings":{
                  "3d56d0d9753fcbe48edbccc5b323b1eb63a466a7b9a703574773906edb9fd159":{
                    "fan2":{
                        "channel_name":"fan2",
                        "speed_fixed":100,
                        "lighting":null,
                        "lcd":null,
                        "reset_to_default":null,
                        "profile_uid":null
                    },
                    "fan1":{
                        "channel_name":"fan1",
                        "speed_fixed":100,
                        "lighting":null,
                        "lcd":null,
                        "reset_to_default":null,
                        "profile_uid":null
                    }
                  },
                  "4b9cd1bc5fb2921253e6b7dd5b1b011086ea529d915a86b3560c236084452807":{
                    "pump":{
                        "channel_name":"pump",
                        "speed_fixed":100,
                        "lighting":null,
                        "lcd":null,
                        "reset_to_default":null,
                        "profile_uid":null
                    }
                  },
                  "7bfee7e15e0af819a1c74ac2f088d69197bdae5f361d2af4da2960c931be3cc7":{
                    "fan1":{
                        "channel_name":"fan1",
                        "speed_fixed":100,
                        "lighting":null,
                        "lcd":null,
                        "reset_to_default":null,
                        "profile_uid":null
                    },
                    "fan3":{
                        "channel_name":"fan3",
                        "speed_fixed":100,
                        "lighting":null,
                        "lcd":null,
                        "reset_to_default":null,
                        "profile_uid":null
                    },
                    "fan4":{
                        "channel_name":"fan4",
                        "speed_fixed":100,
                        "lighting":null,
                        "lcd":null,
                        "reset_to_default":null,
                        "profile_uid":null
                    }
                  }
              }
            }
        ],
        "order":[
            "ef625307-76be-4b07-a4d4-18905be08051",
            "d8d9832b-cc00-43dc-8f9b-221551c5fd8d"
        ],
        "current_active_mode":"ef625307-76be-4b07-a4d4-18905be08051",
        "previous_active_mode":"d8d9832b-cc00-43dc-8f9b-221551c5fd8d"
      }
    '';
    mode = "0644";
  };
}
