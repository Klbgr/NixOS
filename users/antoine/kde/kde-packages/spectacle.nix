{ ... }:

{
  home-manager.users.antoine =
    { pkgs, ... }:

    {
      home.packages = with pkgs; [
        (kdePackages.spectacle.override {
          tesseractLanguages = [
            "eng"
            "fra"
          ];
        })
      ];

      xdg.configFile.spectaclerc.text = ''
        [General]
        ocrLanguages=eng,fra
      '';
    };
}
