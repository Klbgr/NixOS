{ ... }:

{
  home-manager.users.antoine =
    { pkgs, ... }:
    let
      apprenticevr = pkgs.appimageTools.wrapType2 rec {
        pname = "apprenticevr";
        version = "2.1.0";
        src = pkgs.fetchurl {
          url = "https://github.com/mula-bb/apprenticeVrSrc/releases/download/v${version}/apprenticevr-${version}-x86_64.AppImage";
          hash = "sha256-yOUJnIm35an/uCHcciSPQ2q6WKa9FuWZIxQEH4Ma598=";
        };

        extraInstallCommands = ''
          install -m 444 -D ${
            pkgs.fetchurl {
              url = "https://raw.githubusercontent.com/jimzrt/apprenticevr/main/build/icon.svg";
              hash = "sha256-sU1zMhcElKg2kFFXBdhYgun2lzfkxDaI8Gf3m0VK2AQ=";
            }
          } $out/share/icons/hicolor/512x512/apps/apprenticevr.svg

          mkdir -p $out/share/applications
          cp ${
            pkgs.makeDesktopItem {
              name = "apprenticevr";
              desktopName = "ApprenticeVR";
              exec = "apprenticevr";
              icon = "apprenticevr";
              categories = [ "Game" ];
              comment = "Managing and sideloading content onto Meta Quest devices";
            }
          }/share/applications/*.desktop $out/share/applications/
        '';
      };
    in
    {
      home.packages = [
        apprenticevr
      ];
    };
}
