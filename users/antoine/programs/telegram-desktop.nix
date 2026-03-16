{ ... }:

{
  home-manager.users.antoine =
    { pkgs, ... }:

    {
      home.packages = with pkgs; [
        telegram-desktop
      ];

      xdg.configFile."autostart/Telegram.desktop".text = ''
        [Desktop Entry]
        Type = Application
        Name = Telegram
        Exec = Telegram -startintray
      '';
    };
}
