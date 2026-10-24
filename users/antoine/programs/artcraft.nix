{ ... }:

{
  home-manager.users.antoine =
    { inputs, ... }:

    {
      imports = [
        inputs.nix-craftapps.homeManagerModules.default
      ];

      programs.craftapps = {
        enable = true;
        apps = {
          photocraft.enable = true;
          pdfcraft.enable = true;
          filmcraft.enable = true;
          gridcraft.enable = true;
          wordcraft.enable = true;
          deckcraft.enable = true;
        };
      };
    };
}
