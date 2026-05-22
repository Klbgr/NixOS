{ inputs, ... }:

{
  imports = [
    inputs.ayuz.nixosModules.default
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
        inputs.ayuz.homeManagerModules.default
      ];

      programs.ayuz = {
        enable = true;
        autostart = true;
      };
    };
}
