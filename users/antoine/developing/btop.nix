{ ... }:

{
  home-manager.users.antoine =
    { pkgs, ... }:

    {
      programs.btop = {
        enable = true;
        package = pkgs.btop.override {
          cudaSupport = true;
          rocmSupport = true;
        };
      };
    };
}
