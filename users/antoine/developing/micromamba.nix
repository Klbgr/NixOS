{ pkgs, ... }:

{
  home-manager.users.antoine =
    { config, pkgs, ... }:

    {
      home.packages = with pkgs; [
        micromamba
      ];

      home.file.".mambarc".text = ''
        auto_activate_base: false
        envs_dirs:
          - ${config.home.homeDirectory}/.mamba/envs
        pkgs_dirs:
          - ${config.home.homeDirectory}/.mamba/pkgs
      '';

      programs.bash = {
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
