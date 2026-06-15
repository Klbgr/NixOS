{ pkgs, ... }:
let
  pegasusIcon = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/mmatyas/pegasus-frontend/refs/heads/master/assets/icon.png";
    hash = "sha256-u5Yb/JjrJ2ueWZyFsyGgQmVc8hMnVv8ycfNp+UcO7EU=";
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
