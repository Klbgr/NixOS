{ ... }:

{
  home-manager.users.antoine =
    { lib, pkgs, ... }:
    let
      presets-src = pkgs.fetchFromGitHub {
        owner = "JackHack96";
        repo = "EasyEffects-presets";
        rev = "master";
        sha256 = "sha256-9lSYaWGIQ9K53NwQULmbdDxnS4NijmnOEUvFQWjEF08=";
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
            allFiles = builtins.readDir presets-src;
            jsonFiles = lib.filterAttrs (name: type: type == "regular" && lib.hasSuffix ".json" name) allFiles;
          in
          lib.mapAttrs' (name: value: {
            name = "easyeffects/output/${name}";
            value.source = "${presets-src}/${name}";
          }) jsonFiles
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
