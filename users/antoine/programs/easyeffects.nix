{ ... }:

{
  home-manager.users.antoine =
    { lib, pkgs, ... }:
    {
      home.packages = with pkgs; [
        easyeffects
      ];

      xdg.configFile = {
        "easyeffects/db/easyeffectsrc".text = lib.generators.toINI { } {
          StreamOutputs = {
            plugins = "bass_enhancer#0,crystalizer#0";
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
          Exec = easyeffects --hide-window
        '';
      };
    };
}
