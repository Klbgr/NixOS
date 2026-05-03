{ pkgs, config, ... }:
let
  ayuz-flake = builtins.getFlake "github:Traciges/Ayuz";
in
{
  imports = [
    ayuz-flake.nixosModules.default
  ];

  services.ayuz = {
    enable = true;
    supportMyAsusKey = true;
    fnKeyMode = "shortcut";
  };

  home-manager.users.antoine =
    { ... }:

    {
      imports = [
        ayuz-flake.homeManagerModules.default
      ];

      programs.ayuz = {
        enable = true;
        autostart = true;
      };
    };
}
