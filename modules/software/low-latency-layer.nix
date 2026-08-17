{ inputs, pkgs, ... }:

{
  environment.variables = {
    LOW_LATENCY_LAYER = "1";
    LOW_LATENCY_LAYER_REFLEX = "1";
    DXVK_CONFIG = "dxgi.hideAmdGpu = True";
  };

  hardware.graphics.extraPackages = [
    inputs.chaotic.packages.${pkgs.stdenv.system}.low-latency-layer
  ];
}
