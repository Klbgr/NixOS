{ pkgs, ... }:

{
  home.packages = with pkgs; [
    kdePackages.qtstyleplugin-kvantum
  ];

  qt = {
    style.name = "kvantum";
    kde.settings."Kvantum/kvantum.kvconfig".General.theme = "";
  };

  programs = {
    konsole.profiles.custom.colorScheme = "";
    plasma = {
      kscreenlocker.appearance.wallpaper = "";
      workspace = {
        colorScheme = "";
        cursor.theme = "";
        iconTheme = "";
        splashScreen.theme = "";
        theme = "";
        wallpaper = "";
        windowDecorations = {
          library = "org.kde.kwin.aurorae";
          theme = "";
        };
      };
    };
  };
}
