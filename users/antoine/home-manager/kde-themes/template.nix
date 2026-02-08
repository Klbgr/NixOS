{ pkgs, ... }:
let
  wallpaper = "";
in
{
  home.packages = with pkgs; [
  ];

  qt = {
    style.name = "kvantum";
    kde.settings."Kvantum/kvantum.kvconfig".General.theme = "";
  };

  programs = {
    konsole.profiles.custom.colorScheme = "";
    plasma = {
      kscreenlocker.appearance.wallpaper = wallpaper;
      workspace = {
        colorScheme = "";
        cursor.theme = "";
        iconTheme = "";
        splashScreen.theme = "";
        theme = "";
        wallpaper = wallpaper;
        windowDecorations = {
          library = "org.kde.kwin.aurorae";
          theme = "__aurorae__svg__";
        };
      };
    };
  };
}
