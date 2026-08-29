{ ... }:

{
  home-manager.users.antoine =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        ookla-speedtest
      ];
    };
}
