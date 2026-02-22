{ ... }:

{
  home-manager.users.antoine =
    { pkgs, ... }:

    {
      home.packages = with pkgs; [
        mangohud
        goverlay
        vulkan-tools
        protonup-qt
        lutris
        heroic
        atlauncher
      ];
    };

  programs = {
    steam = {
      enable = true;
      gamescopeSession.enable = true;
    };
    gamemode.enable = true;
  };
}
