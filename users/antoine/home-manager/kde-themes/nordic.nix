{ pkgs, ... }:
let
wallpaper = "${pkgs.kdePackages.plasma-workspace-wallpapers}/share/wallpapers/Mountain/";
{
  home.packages = with pkgs; [
    nordic
    tela-icon-theme
  ];

  qt = {
    style.name = "kvantum";
    kde.settings."Kvantum/kvantum.kvconfig".General.theme = "Nordic-Darker";
  };

  programs = {
    konsole.profiles.custom.colorScheme = "Nordic";
    plasma = {
      kscreenlocker.appearance.wallpaper = wallpaper;
      workspace = {
        colorScheme = "NordicDarker";
        cursor.theme = "Nordic-cursors";
        iconTheme = "Tela-nord";
        splashScreen.theme = "Nordic-darker";
        theme = "Nordic-darker";
        wallpaper = wallpaper;
        windowDecorations = {
          library = "org.kde.kwin.aurorae";
          theme = "__aurorae__svg__Nordic";
        };
      };
    };
  };
}
