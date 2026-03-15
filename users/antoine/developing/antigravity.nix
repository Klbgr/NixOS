{ ... }:

{
  home-manager.users.antoine =
    { pkgs, ... }:

    {
      home.packages = with pkgs; [
        nixfmt
        nixd
        nix-search-cli
        clang-tools
      ];

      programs.vscode = {
        enable = true;
        package =
          (pkgs.symlinkJoin {
            name = "antigravity-wrapped";
            paths = [ pkgs.antigravity ];
            postBuild = ''
              ln -s ${pkgs.antigravity}/lib/antigravity/resources/app/product.json $out/product.json
            '';
          })
          // {
            inherit (pkgs.antigravity) executableName pname version;
          };
        profiles.default = {
          extensions = with pkgs.vscode-extensions; [
            ms-ceintl.vscode-language-pack-fr
            jnoortheen.nix-ide
            llvm-vs-code-extensions.vscode-clangd
            ms-python.python
            ms-python.debugpy
            ms-python.black-formatter
            golang.go
          ];
          userSettings = {
            "python.condaPath" = "${pkgs.micromamba}/bin/micromamba";

            "nix.enableLanguageServer" = true;
            "nix.serverPath" = "nixd";
            "nix.serverSettings" = {
              "nixd" = {
                "formatting" = {
                  "command" = [
                    "nixfmt"
                  ];
                };
              };
            };

            "git.confirmSync" = false;
            "git.autofetch" = true;
          };
        };
      };
    };
}
