{ ... }:

{
  services.wivrn = {
    enable = true;
    openFirewall = true;
  };

    home-manager.users.antoine =
    { pkgs, ... }:

    {
      home.packages = with pkgs; [
        wayvr
      ];
    };
}
