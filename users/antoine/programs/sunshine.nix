{ pkgs, ... }:
let
  pegasusIcon = pkgs.fetchurl {
    url = "https://cdn2.steamgriddb.com/grid/90b8b243b361a90856ebe6543a502ccd.png";
    hash = "sha256-L4qC0uUHtWNYvplmCxV8JrVZG/RhZge6gEt82v1BgDY=";
  };
in
{
  services.sunshine = {
    enable = true;
    settings = {
      locale = "fr";
      system_tray = "disabled";
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
        }
        {
          name = "Pegasus";
          detached = [
            "setsid pegasus-fe"
          ];
          "prep-cmd" = [
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
}
