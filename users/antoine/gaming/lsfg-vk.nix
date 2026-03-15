{ ... }:

{
  home-manager.users.antoine =
    { pkgs, ... }:

    {
      home.packages = with pkgs; [
        lsfg-vk
        lsfg-vk-ui
      ];
    };
}
