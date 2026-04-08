{ ... }:

{
  home-manager.users.antoine =
    {
      config,
      pkgs,
      ...
    }:
    let
      geminiIcon =
        let
          rawIcon = pkgs.fetchurl {
            url = "https://upload.wikimedia.org/wikipedia/commons/thumb/1/1d/Google_Gemini_icon_2025.svg/1280px-Google_Gemini_icon_2025.svg.png";
            sha256 = "sha256-ntHMZdVhvnx5I496JeTnPoU47vtPh1Wahr1tV/Hl00Y=";
          };
        in
        pkgs.runCommand "gemini.png"
          {
            nativeBuildInputs = [ pkgs.imagemagick ];
          }
          ''
            magick "${rawIcon}" -background none -gravity center -extent 125% $out
          '';

      geminiCmd = pkgs.writeShellScriptBin "gemini" ''
        exec google-chrome-stable --user-data-dir="${config.home.homeDirectory}/.config/gemini" --app=https://gemini.google.com --class=chrome-gemini.google.com__-Default --name=chrome-gemini.google.com__-Default "$@"
      '';

      gemini = pkgs.makeDesktopItem {
        name = "chrome-gemini.google.com__-Default";
        desktopName = "Gemini";
        genericName = "Google Gemini";
        exec = "gemini";
        terminal = false;
        categories = [ "Network" ];
        type = "Application";
        icon = "${geminiIcon}";
        startupWMClass = "chrome-gemini.google.com__-Default";
      };
    in
    {
      home.packages = with pkgs; [
        (google-chrome.override {
          commandLineArgs = [
            "--enable-features=TouchpadOverscrollHistoryNavigation"
            "--ozone-platform-hint=auto"
          ];
        })
        gemini
        geminiCmd
      ];
    };
}
