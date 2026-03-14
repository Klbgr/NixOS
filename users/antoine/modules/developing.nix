{ ... }:

{
  home-manager.users.antoine =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        nvtopPackages.full
        wget
        nixfmt
        nix-search-cli
        conda
        android-tools
        antigravity
      ];

      programs = {
        btop = {
          enable = true;
        };
        gcc = {
          enable = true;
        };
        git = {
          enable = true;
          settings = {
            user.email = "qiuantoine@gmail.com";
            user.name = "Klbgr";
          };
        };
        vscode = {
          enable = true;
        };
      };
    };
}
