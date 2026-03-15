{ pkgs, ... }:

{
  home-manager.users.antoine =
    { config, pkgs, ... }:

    {
      home.packages = with pkgs; [
        nvtopPackages.full
        wget
        nixfmt
        nixd
        nix-search-cli
        android-tools
        clang-tools
        micromamba
      ];

      home.file.".mambarc".text = ''
        auto_activate_base: false
        envs_dirs:
          - ${config.home.homeDirectory}/.mamba/envs
        pkgs_dirs:
          - ${config.home.homeDirectory}/.mamba/pkgs
      '';

      programs = {
        bash = {
          bashrcExtra = ''
            # >>> mamba initialize >>>
            # !! Contents within this block are managed by 'micromamba shell init' !!
            export MAMBA_EXE='${pkgs.micromamba}/bin/micromamba';
            export MAMBA_ROOT_PREFIX='${config.home.homeDirectory}/.local/share/mamba';
            __mamba_setup="$("$MAMBA_EXE" shell hook --shell bash --root-prefix "$MAMBA_ROOT_PREFIX" 2> /dev/null)"
            if [ $? -eq 0 ]; then
                eval "$__mamba_setup"
            else
                alias micromamba="$MAMBA_EXE"  # Fallback on help from micromamba activate
            fi
            unset __mamba_setup
            # <<< mamba initialize <<<
          '';
          shellAliases = {
            conda = "micromamba";
            mamba = "micromamba";
          };
        };
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
    };

  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      zlib
      zstd
      stdenv.cc.cc
      curl
      openssl
      attr
      libssh
      bzip2
      libxml2
      acl
      libsodium
      util-linux
      xz
      systemd
      xorg.libxcb
    ];
  };
}
