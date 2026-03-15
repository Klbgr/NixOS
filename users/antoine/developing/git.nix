{ ... }:

{
  home-manager.users.antoine =
    { ... }:

    {
      programs.git = {
        enable = true;
        settings = {
          user.email = "qiuantoine@gmail.com";
          user.name = "Klbgr";
        };
      };
    };
}
