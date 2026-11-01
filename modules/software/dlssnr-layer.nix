{ pkgs, ... }:
let
  dlssnr-layer = pkgs.stdenv.mkDerivation rec {
    pname = "dlssnr-layer";
    version = "0.3.1-2";

    src = pkgs.fetchurl {
      url = "https://github.com/bmitch87/DLSS5VKLayer/releases/download/${version}/dlssnr-${version}-linux-x86_64.tar.gz";
      hash = "sha256-Q/0AFyCj4VcEwbuOoDx2i0BuBYyOsoWasOvIs81I+VU=";
    };

    sourceSrc = pkgs.fetchurl {
      url = "https://github.com/bmitch87/DLSS5VKLayer/archive/refs/tags/${version}.tar.gz";
      hash = "sha256-1u6XTv9QG4V/2g0oVbi2Iv5/dUhhT85aZqnIiDtQXxo=";
    };

    nativeBuildInputs = with pkgs; [
      autoPatchelfHook
      clang
      makeWrapper
      meson
      ninja
      pkg-config
    ];

    dontUseMesonConfigure = true;

    buildInputs = with pkgs; [
      llvm
      vulkan-headers
      vulkan-loader
      libx11
      libxrandr
      qt6.qtbase
      gcc-unwrapped.lib
    ];

    dontWrapQtApps = true;

    autoPatchelfIgnoreMissingDeps = [
      "libVkLayer_NV_dlssnr.so"
    ];

    unpackPhase = ''
      runHook preUnpack

      mkdir source release
      tar -xzf $sourceSrc --strip-components=1 -C source
      tar -xzf $src --strip-components=1 -C release
      sourceRoot=source

      runHook postUnpack
    '';

    patches = [ ./dlssnr-vulkan-allocation.patch ];

    buildPhase = ''
      runHook preBuild
      meson setup build \
        --native-file meson/native-clang.ini \
        -Dlayer32=false \
        -Dbuildtype=release
      ninja -C build layer_linux/libVkLayer_NV_dlssnr.so
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out
      cp -r ../release/root/usr/* $out/

      cp build/layer_linux/libVkLayer_NV_dlssnr.so \
        $out/lib64/dlssnr/layer/libVkLayer_NV_dlssnr.so

      if [ -d "$out/lib64" ] && [ ! -d "$out/lib" ]; then
        mv $out/lib64 $out/lib
      fi

      # Binary symlinks (runner_probe & dlssnr-shmctl live in lib/dlssnr/bin)
      ln -sf ../lib/dlssnr/bin/runner_probe $out/bin/dlssnr-runner-probe
      ln -sf ../lib/dlssnr/bin/dlssnr-shmctl $out/bin/dlssnr-shmctl

      # Patch Vulkan layer JSON paths
      substituteInPlace $out/share/vulkan/implicit_layer.d/VK_LAYER_NV_dlssnr.x86_64.json \
        --replace-fail "/usr/lib64/dlssnr/layer/libVkLayer_NV_dlssnr.so" "$out/lib/dlssnr/layer/libVkLayer_NV_dlssnr.so"

      substituteInPlace $out/share/vulkan/implicit_layer.d/VK_LAYER_NV_dlssnr.i686.json \
        --replace-fail "/usr/lib64/dlssnr/layer32/libVkLayer_NV_dlssnr.so" "$out/lib/dlssnr/layer32/libVkLayer_NV_dlssnr.so"

      # Patch hardcoded /usr/ paths directly in the helper script (already located at $out/bin/dlssnr-helper)
      if [ -f "$out/bin/dlssnr-helper" ]; then
        substituteInPlace $out/bin/dlssnr-helper \
          --replace-quiet "/usr/lib64/dlssnr" "$out/lib/dlssnr" \
          --replace-quiet "/usr/lib/dlssnr" "$out/lib/dlssnr" \
          --replace-quiet "/usr/share/dlssnr" "$out/share/dlssnr"
      fi

      runHook postInstall
    '';

    postFixup = ''
      # Keep the helper on the host. It invokes the configured Proton runner
      # itself, and the SHM path must be shared with the Vulkan layer.
      if [ -f "$out/bin/dlssnr-helper" ]; then
        mv $out/bin/dlssnr-helper $out/bin/.dlssnr-helper-unwrapped

        local helperPath="${pkgs.lib.makeBinPath [
          pkgs.bash
          pkgs.coreutils
          pkgs.gawk
          pkgs.gnugrep
          pkgs.gnused
          pkgs.util-linux
          pkgs.pciutils
          pkgs.procps
        ]}"

        cat > $out/bin/dlssnr-helper << EOF
#!${pkgs.bash}/bin/bash
export PATH="$helperPath\''${PATH:+:\$PATH}"
export LD_LIBRARY_PATH="${pkgs.vulkan-loader}/lib\''${LD_LIBRARY_PATH:+:\$LD_LIBRARY_PATH}"
export DLSSNR_INSTALL_DIR="\''${DLSSNR_INSTALL_DIR:-$out/lib/dlssnr}"
exec $out/bin/.dlssnr-helper-unwrapped "\$@"
EOF
        chmod +x $out/bin/dlssnr-helper
      fi

      # # Wrap dlssnr-gui with steam-run
      # if [ -f "$out/bin/dlssnr-gui" ]; then
      #   mv $out/bin/dlssnr-gui $out/bin/.dlssnr-gui-unwrapped
      #   makeWrapper ${pkgs.steam-run}/bin/steam-run $out/bin/dlssnr-gui \
      #     --add-flags "$out/bin/.dlssnr-gui-unwrapped" \
      #     --set-default DLSSNR_INSTALL_DIR "$out/lib/dlssnr"
      # fi
    '';
  };
in
{
  hardware.graphics = {
    extraPackages = [ dlssnr-layer ];
    extraPackages32 = [ dlssnr-layer ];
  };
  environment.systemPackages = [ dlssnr-layer pkgs.mpv pkgs.vulkan-tools ];

}
