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
      ];

      programs = {
        btop = {
          enable = true;
          settings = {
            theme_background = false;
          };
        };
        gcc = {
          enable = true;
        };
        git = {
          enable = true;
        };
        vscode = {
          enable = true;
        };
      };
    };
}
