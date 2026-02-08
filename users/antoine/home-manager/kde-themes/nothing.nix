{ pkgs, ... }:
let
  nothing = pkgs.stdenv.mkDerivation rec {
    pname = "nothing-kde-theme";
    version = "main";
    src = pkgs.fetchFromGitLab {
      owner = "jomada";
      repo = "Nothing";
      rev = version;
      sha256 = "sha256-DfVj08uMgNLxOr5gOt7fZBspezMPiVJm3H8bSNyW0Kg=";
    };
    installPhase = ''
      mkdir -p $out/share/{color-schemes,plasma/look-and-feel,konsole,plasma/desktoptheme,wallpapers/Nothing,aurorae/themes}

      mv -v color-schemes/* $out/share/color-schemes/
      mv -v look-and-feel/Nothing $out/share/plasma/look-and-feel/
      mv -v konsole/* $out/share/konsole/
      mv -v Nothing $out/share/plasma/desktoptheme/
      mv -v wallpapers/* $out/share/wallpapers/
      mv -v aurorae/Nothing $out/share/aurorae/themes/
    '';
  };

  wallpaper = "${nothing}/share/wallpapers/Nothing3/";
in
{
  home.packages = with pkgs; [
    nothing
    tela-icon-theme
  ];

  # qt = {
  #   style.name = "kvantum";
  #   kde.settings."Kvantum/kvantum.kvconfig".General.theme = "";
  # };

  programs = {
    konsole.profiles.custom.colorScheme = "Nothing";
    plasma = {
      kscreenlocker.appearance.wallpaper = wallpaper;
      workspace = {
        colorScheme = "Nothing";
        # cursor.theme = "";
        iconTheme = "Tela-red";
        # splashScreen.theme = "";
        theme = "Nothing";
        wallpaper = wallpaper;
        windowDecorations = {
          library = "org.kde.kwin.aurorae";
          theme = "__aurorae__svg__Nothing";
        };
      };
    };
  };
}
