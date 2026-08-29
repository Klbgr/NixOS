{ inputs, ... }:

{
  nixpkgs.overlays = [
    inputs.nix-vscode-extensions.overlays.default
  ];

  home-manager.users.antoine =
    { pkgs, lib, ... }:
    let
      vscode-extensions = pkgs.nix-vscode-extensions.vscode-marketplace-release;
    in
    {
      home.packages = with pkgs; [
        python3
        black
        nixfmt
        nixd
        clang-tools
      ];

      programs.vscode = {
        enable = true;
        mutableExtensionsDir = false;
        profiles.default = {
          enableMcpIntegration = false;
          extensions = with vscode-extensions; [
            ms-ceintl.vscode-language-pack-fr

            google.google-antigravity

            ms-python.python
            ms-python.debugpy
            ms-python.vscode-pylance
            ms-python.vscode-python-envs
            ms-python.black-formatter
            njpwerner.autodocstring

            llvm-vs-code-extensions.vscode-clangd
            jeff-hykin.better-cpp-syntax

            jnoortheen.nix-ide
            jeff-hykin.better-nix-syntax

            yzhang.markdown-all-in-one
            davidanson.vscode-markdownlint

            cschlosser.doxdocgen

            mechatroner.rainbow-csv

            oderwat.indent-rainbow
          ];
        };
      };

      home.activation.mergeVSCodeConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        PATCHER="${pkgs.configuration-patcher}/bin/configuration-patcher"

        USER_SETTINGS_FILE="$HOME/.config/Code/User/settings.json"
        ARGV_FILE="$HOME/.vscode/argv.json"

        # $PATCHER json "$ARGV_FILE" '{
        #   "enable-crash-reporter": false,
        #   "locale": "fr"
        # }'

        $PATCHER json "$USER_SETTINGS_FILE" '{
          "extensions.autoCheckUpdates": false,
          "update.mode": "none",
          "telemetry.feedback.enabled": false,
          "telemetry.telemetryLevel": "off",
          "telemetry.editStats.enabled": false,

          "python.useEnvironmentsExtension": true,
          "[python]": {
            "editor.defaultFormatter": "ms-python.black-formatter"
          },
          "black-formatter.interpreter": [
            "python3"
          ],
          "black-formatter.path": [
            "black"
          ],

          "clangd.path": "clangd",

          "git.autofetch": true,
          "git.confirmSync": false,

          "nix.enableLanguageServer": true,
          "nix.formatterPath": "nixfmt",
          "nix.serverPath": "nixd",

          "indentRainbow.indicatorStyle": "light"
        }'       
      '';
    };
}
