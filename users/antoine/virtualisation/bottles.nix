{ ... }:

{
  home-manager.users.antoine =
    { pkgs, ... }:
    #TODO remove once fixed in nixpkgs
    let
      pkgsFixed = pkgs.extend (
        final: prev: {
          openldap = prev.openldap.overrideAttrs (oldAttrs: {
            doCheck = false;
          });
        }
      );
    in
    {
      home.packages = with pkgs; [
        (pkgsFixed.bottles.override {
          removeWarningPopup = true;
        })
      ];
    };
}
