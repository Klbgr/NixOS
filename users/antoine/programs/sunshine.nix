{ ... }:

{
  home-manager.users.antoine =
    { ... }:

    {
      xdg.configFile."sunshine/sunshine.conf".text = ''
        locale = fr
        system_tray = disabled
      '';
    };

  services.sunshine = {
    enable = true;
    autoStart = true;
    capSysAdmin = true;
    openFirewall = true;
  };
}
