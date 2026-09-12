{ inputs, pkgs, ... }:
let
  rogreat = import inputs.rogreat-nur-packages { inherit pkgs; };
in
{
  home-manager.users.antoine =
    { ... }:

    {
      home.packages = [
        rogreat.amethyst-mod-manager
      ];
    };
}
