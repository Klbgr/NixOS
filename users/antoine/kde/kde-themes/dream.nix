{ ... }:

{
  home-manager.users.antoine =
    { pkgs, ... }:
    let
      dream = pkgs.stdenv.mkDerivation rec {
        pname = "dream-kde-theme";
        version = "main";
        src = pkgs.fetchFromGitHub {
          owner = "L4ki";
          repo = "Dream-Plasma-Themes";
          rev = version;
          sha256 = "sha256-7owSCxbFfS70Z9povJI2eyIK0TYXXO3fWdhUXMyW0B8=";
        };
        installPhase = ''
          mkdir -p $out/share/{color-schemes,themes,plasma/look-and-feel,konsole,Kvantum,plasma/desktoptheme,sddm/themes,wallpapers/Dream,aurorae/themes}

          mv -v "Dream Color Schemes"/* $out/share/color-schemes/
          mv -v "Dream GTK Themes"/* $out/share/themes
          mv -v "Dream Global Themes"/*-Color-Global-6 $out/share/plasma/look-and-feel/
          mv -v "Dream Konsole Color Schemes"/* $out/share/konsole/
          mv -v "Dream Kvantum Themes"/* $out/share/Kvantum/
          mv -v "Dream Plasma Themes"/* $out/share/plasma/desktoptheme/
          mv -v "Dream SDDM Login Themes"/*-SDDM-6 $out/share/sddm/themes/
          mv -v "Dream Wallpapers"/* $out/share/wallpapers/Dream/
          mv -v "Dream Window Decorations"/*-Aurorae-6 $out/share/aurorae/themes/
        '';
      };

      wallpaper = "${pkgs.kdePackages.plasma-workspace-wallpapers}/share/wallpapers/Path/";
    in
    {
      home.packages = with pkgs; [
        dream
        tela-icon-theme
        bibata-cursors
      ];

      qt = {
        style.name = "kvantum";
        kde.settings."Kvantum/kvantum.kvconfig".General.theme = "Dream-Lime-Green-Dark-Kvantum";
      };

      programs = {
        konsole.profiles.custom.colorScheme = "Dream-Blur-Lime-Dark-Konsole";
        plasma = {
          kscreenlocker.appearance.wallpaper = wallpaper;
          workspace = {
            colorScheme = "DreamLimeGreenDarkColor";
            cursor.theme = "Bibata-Modern-Classic";
            iconTheme = "Tela-green";
            # splashScreen.theme = "";
            theme = "Dream-Color-Plasma";
            wallpaper = wallpaper;
            windowDecorations = {
              library = "org.kde.kwin.aurorae";
              theme = "__aurorae__svg__Dream-Blur-Color-Dark-Aurorae-6";
            };
          };
        };
      };
    };
}
