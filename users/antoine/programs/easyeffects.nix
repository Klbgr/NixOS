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

      xdg.configFile = {
        "easyeffects/output/Advanced Auto Gain.json".source = "${presets-src}/Advanced Auto Gain.json";
        "easyeffects/db/easyeffectsrc".text = lib.generators.toINI { } {
          StreamOutputs = {
            visiblePage = "pluginsPage";
          };
          Window = {
            showTrayIcon = false;
          };
        };
        "autostart/EasyEffects.desktop".text = ''
          [Desktop Entry]
          Type = Application
          Name = Easy Effects
          Exec = easyeffects --hide-window & easyeffects --load-preset "Advanced Auto Gain"
        '';
      };
    };
}
