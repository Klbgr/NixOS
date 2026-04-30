{ ... }:

{
  home-manager.users.antoine =
    { pkgs, ... }:

    {
      home.packages = with pkgs; [
        python312Packages.kde-material-you-colors
        papirus-icon-theme
        bibata-cursors
      ];

      # qt = {
      #   style.name = "kvantum";
      #   kde.settings."Kvantum/kvantum.kvconfig".General.theme = "Kvantum";
      # };

      programs = {
        konsole.profiles.custom.colorScheme = "MaterialYou";
        plasma = {
          kscreenlocker.appearance.wallpaperPictureOfTheDay.provider = "bing";
          workspace = {
            colorScheme = "MaterialYouLight";
            cursor.theme = "Bibata-Modern-Classic";
            iconTheme = "Papirus";
            soundTheme = "ocean";
            splashScreen.theme = "org.kde.breeze.desktop";
            theme = "default";
            wallpaperPictureOfTheDay.provider = "bing";
            windowDecorations = {
              library = "org.kde.breeze";
              theme = "Breeze";
            };
          };
        };
      };

      xdg.configFile."autostart/KDEMaterialYouColors.desktop".text = ''
        [Desktop Entry]
        Type=Application
        Name=KDE Material You Colors
        Exec=kde-material-you-colors -l
      '';
    };
}
