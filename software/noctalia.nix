{
  inputs,
  lib,
  pkgs,
  ...
}:

{
  nix.settings = {
    extra-substituters = [ "https://noctalia.cachix.org" ];
    extra-trusted-public-keys = [
      "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
    ];
  };

  programs.niri = {
    enable = true;
    useNautilus = false;
  };

  environment.sessionVariables = {
    XDG_CURRENT_DESKTOP = "niri:GNOME";
  };

  environment.systemPackages = [
    inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
    pkgs.xwayland-satellite
  ];

  services.gnome.gnome-keyring.enable = lib.mkForce false;
}
