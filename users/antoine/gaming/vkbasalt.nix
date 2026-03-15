{ ... }:

{
  home-manager.users.antoine =
    { pkgs, ... }:

    {
      home.packages = with pkgs; [
        vkbasalt
        vkbasalt-cli
      ];
    };
}
