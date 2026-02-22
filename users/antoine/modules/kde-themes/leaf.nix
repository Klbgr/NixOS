{ ... }:

{
  home-manager.users.antoine =
    { pkgs, ... }:
    let
      leaf = pkgs.stdenv.mkDerivation rec {
        pname = "leaf-kde-theme";
        version = "main";
        src = pkgs.fetchFromGitHub {
          owner = "qewer33";
          repo = "leaf-kde";
          rev = version;
          sha256 = "sha256-5KY9JmIfwqWd/i2EW4su4v/f7PO/dFyu097Pxn6liWA=";
        };
        installPhase = ''
          mkdir -p $out/share/{color-schemes,plasma/look-and-feel,konsole,plasma/desktoptheme,wallpapers,aurorae/themes}

          mv -v color-schemes/* $out/share/color-schemes/
          mv -v look-and-feel/* $out/share/plasma/look-and-feel/
          mv -v desktoptheme/Leaf $out/share/plasma/desktoptheme/
          mv -v wallpapers/* $out/share/wallpapers/
          mv -v aurorae/* $out/share/aurorae/themes/
          mv -v konsole/* $out/share/konsole/
        '';
      };

      wallpaper = "${leaf}/share/wallpapers/leaf-light";
    in
    {
      home.packages = with pkgs; [
        leaf
        papirus-icon-theme
      ];

      # qt = {
      #   style.name = "kvantum";
      #   kde.settings."Kvantum/kvantum.kvconfig".General.theme = "";
      # };

      programs = {
        konsole.profiles.custom.colorScheme = "Leaf Light";
        plasma = {
          kscreenlocker.appearance.wallpaper = wallpaper;
          workspace = {
            colorScheme = "LeafLight";
            # cursor.theme = "";
            iconTheme = "Papirus";
            splashScreen.theme = "leaf-light";
            theme = "Leaf";
            wallpaper = wallpaper;
            windowDecorations = {
              library = "org.kde.kwin.aurorae";
              theme = "__aurorae__svg__leaf-light";
            };
          };
        };
      };
    };
}
