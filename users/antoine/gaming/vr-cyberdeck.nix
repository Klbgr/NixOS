{ ... }:

{
  home-manager.users.antoine =
    { pkgs, ... }:
    let
      vr-cyberdeck = pkgs.appimageTools.wrapType2 rec {
        pname = "vr-cyberdeck";
        version = "1.2.7";
        src = pkgs.fetchurl {
          url = "https://github.com/KaladinDMP/VR-CyberDeck/releases/download/v${version}/vr-cyberdeck-${version}-x86_64.AppImage";
          hash = "sha256-fPgdXIlewyK7zvpmo+0BDTB5Q5b9hd6qSw8H9GKAV2c=";
        };

        extraInstallCommands = ''
          install -m 444 -D ${
            pkgs.fetchurl {
              url = "https://raw.githubusercontent.com/KaladinDMP/VR-CyberDeck/refs/heads/main/resources/icon.svg";
              hash = "sha256-nC201nrGylrjeXqTVmGGsJHuIwiMb7Wsio7ZhXOWTjU=";
            }
          } $out/share/icons/hicolor/512x512/apps/vr-cyberdeck.svg

          mkdir -p $out/share/applications
          cp ${
            pkgs.makeDesktopItem {
              name = "vr-cyberdeck";
              desktopName = "VR CyberDeck";
              exec = "vr-cyberdeck";
              icon = "vr-cyberdeck";
              categories = [ "Game" ];
              comment = "A cyberpunk flavored, multi OS, sideloader for the Meta Quest devices";
            }
          }/share/applications/*.desktop $out/share/applications/
        '';
      };
    in
    {
      home.packages = [
        vr-cyberdeck
      ];
    };
}
