{ pkgs, ... }:
let
  low-latency-layer = pkgs.stdenv.mkDerivation rec {
    pname = "low-latency-layer";
    version = "main";
    src = pkgs.fetchFromGitHub {
      owner = "Korthos-Software";
      repo = "low_latency_layer";
      rev = version;
      hash = "sha256-bhrgpTiyxil3mlzgWWf0r7LUasHzXIUctoaEQvCKWXE=";
    };

    nativeBuildInputs = [
      pkgs.cmake
    ];

    buildInputs = [
      pkgs.vulkan-headers
      pkgs.vulkan-utility-libraries
      pkgs.vulkan-loader
    ];
  };
in
{
  environment.variables = {
    LOW_LATENCY_LAYER = "1";
    LOW_LATENCY_LAYER_REFLEX = "1";
    DXVK_CONFIG = "dxgi.hideAmdGpu = True";
  };

  hardware.graphics.extraPackages = [ low-latency-layer ];
}
