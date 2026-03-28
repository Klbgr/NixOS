{ ... }:

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
          name = "Steam Big Picture";
          detached = [
            "setsid steam steam://open/bigpicture"
          ];
          "prep-cmd" = [
            {
              do = "";
              undo = "setsid steam steam://close/bigpicture";
            }
          ];
          "image-path" = "steam.png";
        }
      ];
    };
  };
}
