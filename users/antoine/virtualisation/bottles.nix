{ ... }:

{
  home-manager.users.antoine =
    { pkgs, ... }:

    {
      home.packages = with pkgs; [
        (bottles.override {
          removeWarningPopup = true;
        })
      ];
    };
}
