{ pkgs, ... }:
let
  pegasusIcon = pkgs.fetchurl {
    url = "https://cdn2.steamgriddb.com/grid/90b8b243b361a90856ebe6543a502ccd.png";
    hash = "sha256-L4qC0uUHtWNYvplmCxV8JrVZG/RhZge6gEt82v1BgDY=";
  };

  sunsync-virtual-display = pkgs.stdenv.mkDerivation rec {
    pname = "sunsync-virtual-display";
    version = "main";
    src = pkgs.fetchFromGitHub {
      owner = "OscarTienda";
      repo = "SunSync";
      rev = version;
      hash = "sha256-Gt0SY/SHGftsbYMPEIl234RPsWFphk/dU4vHf07V36E=";
    };

    nativeBuildInputs = [ pkgs.makeWrapper ];

    buildInputs = with pkgs.kdePackages; [
      krfb
      libkscreen
      qttools
    ];

    dontBuild = true;
    dontWrapQtApps = true;

    installPhase = ''
      runHook preInstall

      mkdir -p $out/bin
      mkdir -p $out/share/applications

      cp scripts/sunshine-start-vmon.sh $out/bin/
      cp scripts/sunshine-stop-vmon.sh $out/bin/

      chmod +x $out/bin/*

      cp ${pkgs.kdePackages.krfb}/share/applications/org.kde.krfb.virtualmonitor.desktop $out/share/applications/org.kde.krfb-virtualmonitor.desktop

      runHook postInstall
    '';

    postFixup = ''
      for script in $out/bin/*; do
        wrapProgram "$script" \
          --prefix PATH : ${
            pkgs.lib.makeBinPath [
              pkgs.kdePackages.krfb
              pkgs.kdePackages.libkscreen
              pkgs.kdePackages.qttools
            ]
          }
      done
    '';
  };
in
{
  services.sunshine = {
    enable = true;
    settings = {
      locale = "fr";
      system_tray = "disabled";
      capture = "kwin";
    };
    autoStart = true;
    capSysAdmin = true;
    openFirewall = true;
    applications = {
      env = {
        PATH = "$(PATH):$(HOME)/.local/bin";
      };
      apps = [
        {
          name = "Desktop";
          "image-path" = "desktop.png";
          "prep-cmd" = [
            {
              do = "${sunsync-virtual-display}/bin/sunshine-start-vmon.sh";
              undo = "${sunsync-virtual-display}/bin/sunshine-stop-vmon.sh";
            }
          ];
        }
        {
          name = "Pegasus";
          detached = [
            "setsid pegasus-fe"
          ];
          "prep-cmd" = [
            {
              do = "${sunsync-virtual-display}/bin/sunshine-start-vmon.sh";
              undo = "${sunsync-virtual-display}/bin/sunshine-stop-vmon.sh";
            }
            {
              do = "";
              undo = "setsid pkill -9 pegasus-fe";
            }
          ];
          "image-path" = pegasusIcon;
        }
      ];
    };
  };

  environment.systemPackages = [
    sunsync-virtual-display
  ];
}
