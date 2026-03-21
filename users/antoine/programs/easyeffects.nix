{ ... }:

{
  home-manager.users.antoine =
    { lib, pkgs, ... }:
    let
      JackHack96-presets-src = pkgs.fetchFromGitHub {
        owner = "JackHack96";
        repo = "EasyEffects-presets";
        rev = "master";
        sha256 = "sha256-9lSYaWGIQ9K53NwQULmbdDxnS4NijmnOEUvFQWjEF08=";
      };
      RaduTek-presets-src = pkgs.fetchFromGitHub {
        owner = "RaduTek";
        repo = "EasyEffects-presets";
        rev = "main";
        sha256 = "sha256-V+QSKC8MRmvPG3TIz5RcB+xZFHmT9Ay9r/nGqvleyQQ=";
      };
    in
    {
      home.packages = with pkgs; [
        easyeffects
      ];

      home.activation.mergeEasyEffectsConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        PATCHER="${pkgs.configuration-patcher}/bin/configuration-patcher"

        CONFIG_FILE="$HOME/.config/easyeffects/db/easyeffectsrc"

        $PATCHER ini "$CONFIG_FILE" "StreamOutputs" "visiblePage" "pluginsPage"        
        $PATCHER ini "$CONFIG_FILE" "Window" "outputAutoloadingFallbackPreset" "Bass Enhancing + Perfect EQ"        
        $PATCHER ini "$CONFIG_FILE" "Window" "outputAutoloadingUsesFallback" "true"        
        $PATCHER ini "$CONFIG_FILE" "Window" "showTrayIcon" "false"        
      '';

      xdg.configFile =
        (
          let
            mkPresets =
              src:
              lib.mapAttrs'
                (name: type: {
                  name = "easyeffects/output/${name}";
                  value.source = "${src}/${name}";
                })
                (
                  lib.filterAttrs (name: type: type == "regular" && lib.hasSuffix ".json" name) (builtins.readDir src)
                );
          in
          mkPresets JackHack96-presets-src // mkPresets RaduTek-presets-src
        )
        // {
          "autostart/EasyEffects.desktop".text = ''
            [Desktop Entry]
            Type = Application
            Name = Easy Effects
            Exec = easyeffects --service-mode --hide-window
          '';
        };
    };
}
