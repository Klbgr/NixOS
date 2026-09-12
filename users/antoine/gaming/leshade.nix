{ ... }:

{
  home-manager.users.antoine =
    { pkgs, ... }:
    let
      leshade = pkgs.appimageTools.wrapType2 rec {
        pname = "leshade";
        version = "2.5.0";
        src = pkgs.fetchurl {
          url = "https://github.com/Ishidawg/LeShade/releases/download/${version}/LeShade-x86_64.AppImage";
          hash = "sha256-TwZAmBO/rgOkXD52Em3qwvt/mrgKleja3NlsW+QJFdk=";
        };

        extraInstallCommands = ''
          install -m 444 -D ${
            pkgs.fetchurl {
              url = "https://raw.githubusercontent.com/Ishidawg/LeShade/refs/heads/main/assets/logo.png";
              hash = "sha256-1cNQZASbofMQoGrfoUmjTF90rK3cAQu7xyvsAigHQfg=";
            }
          } $out/share/icons/hicolor/512x512/apps/leshade.png

          mkdir -p $out/share/applications
          cp ${
            pkgs.makeDesktopItem {
              name = "leshade";
              desktopName = "LeShade";
              exec = "leshade";
              icon = "leshade";
              categories = [ "Game" ];
              comment = "An ReShade manager for linux";
            }
          }/share/applications/*.desktop $out/share/applications/
        '';
      };
    in
    {
      home.packages = [
        leshade
      ];
    };
}
