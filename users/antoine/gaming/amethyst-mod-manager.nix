{ inputs, pkgs, ... }:

{
  home-manager.users.antoine =
    { ... }:

    {
      home.packages = [
        inputs.amethyst-mod-manager.packages.${pkgs.system}.default
      ];
    };
}
