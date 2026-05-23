{ ... }:

{
  #TODO remove once fixed in nixpkgs
  nixpkgs.overlays = [
    (final: prev: {
      pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [
        (pythonFinal: pythonPrev: {
          jedi-language-server = pythonPrev.jedi-language-server.overrideAttrs (oldAttrs: {
            dontCheckRuntimeDeps = true;
            doCheck = false;
          });
        })
      ];
    })
  ];

  home-manager.users.antoine =
    { pkgs, ... }:

    {
      home.packages = with pkgs; [
        nixfmt
        nixd
        nix-search-cli
        hydra-check
        clang-tools
      ];

      programs.antigravity = {
        enable = true;
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

      programs.bash.shellAliases.code = "antigravity";
    };
}
