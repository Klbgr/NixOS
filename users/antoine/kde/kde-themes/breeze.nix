{ ... }:

{
  home-manager.users.antoine =
    { pkgs, ... }:
    let
      wallpaper = "${pkgs.kdePackages.plasma-workspace-wallpapers}/share/wallpapers/Next/";
    in
    {
      home.packages = with pkgs; [
        papirus-icon-theme
      ];

      # qt = {
      #   style.name = "kvantum";
      #   kde.settings."Kvantum/kvantum.kvconfig".General.theme = "Kvantum";
      # };

      programs = {
        konsole.profiles.custom.colorScheme = "Breeze";
        plasma = {
          kscreenlocker.appearance.wallpaper = wallpaper;
          workspace = {
            colorScheme = "BreezeLight";
            cursor.theme = "breeze_cursors";
            iconTheme = "Papirus";
            soundTheme = "ocean";
            splashScreen.theme = "org.kde.breeze.desktop";
            theme = "default";
            wallpaper = wallpaper;
            windowDecorations = {
              library = "org.kde.breeze";
              theme = "Breeze";
            };
          };
        };
      };
    };
}
