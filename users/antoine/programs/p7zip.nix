{ ... }:

{
  home-manager.users.antoine =
    { pkgs, ... }:

    {
      home.packages = with pkgs; [
        p7zip
      ];
    };
}
