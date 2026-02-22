{ ... }:

{
  home-manager.users.antoine =
    { pkgs, ... }:
    let
      orchis = pkgs.stdenv.mkDerivation rec {
        pname = "orchis-kde-theme";
        version = "main";
        src = pkgs.fetchFromGitHub {
          owner = "vinceliuice";
          repo = "Orchis-kde";
          rev = version;
          sha256 = "sha256-mO1AVrnXNdg3Rftj0cQWef/RrBgSDy5kaMHagwKywEo=";
        };
        installPhase = ''
          mkdir -p $out/share/{color-schemes,plasma/look-and-feel,Kvantum,plasma/desktoptheme,sddm/themes,wallpapers,aurorae/themes}

          mv -v color-schemes/* $out/share/color-schemes/
          mv -v plasma/look-and-feel/* $out/share/plasma/look-and-feel/
          mv -v plasma/desktoptheme/* $out/share/plasma/desktoptheme/
          mv -v wallpaper/Orchis $out/share/wallpapers/
          mv -v aurorae/* $out/share/aurorae/themes/
          mv -v Kvantum/* $out/share/Kvantum/
          mv -v sddm/6.0/Orchis $out/share/sddm/themes/
        '';
      };

      wallpaper = "${orchis}/share/wallpapers/Orchis";
    in
    {
      home.packages = with pkgs; [
        orchis
        tela-icon-theme
      ];

      qt = {
        style.name = "kvantum";
        kde.settings."Kvantum/kvantum.kvconfig".General.theme = "Orchis";
      };

      programs = {
        # konsole.profiles.custom.colorScheme = "";
        plasma = {
          kscreenlocker.appearance.wallpaper = wallpaper;
          workspace = {
            colorScheme = "Orchis";
            # cursor.theme = "";
            iconTheme = "Tela";
            splashScreen.theme = "com.github.vinceliuice.Orchis";
            theme = "Orchis";
            wallpaper = wallpaper;
            windowDecorations = {
              library = "org.kde.kwin.aurorae";
              theme = "__aurorae__svg__Orchis";
            };
          };
        };
      };
    };
}
