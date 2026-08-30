{ ... }:

{
  home-manager.users.antoine =
    { ... }:

    {
      programs.btop = {
        enable = true;
        settings = {
          update_ms = 100;
        };
      };
    };
}
