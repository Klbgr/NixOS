{
  inputs,
  pkgs,
  lib,
  config,
  ...
}:
let
  gazeOpenVINO = inputs.gaze.packages.${pkgs.stdenv.hostPlatform.system}.gaze.overrideAttrs (old: {
    buildInputs = (old.buildInputs or [ ]) ++ [ pkgs.openvino ];
    buildPhase = ''
      runHook preBuild
      cargo build --release --offline --features openvino -p gaze
      cargo build --release --offline --features openvino -p gaze-cli -p pam-gaze -p pam-gaze-grosshack
      runHook postBuild
    '';
  });
in
{
  imports = [
    ./hardware-configuration.nix
    ../pc.nix
    ../../modules/hardware/intel-cpu.nix
    ../../modules/hardware/nvidia-gpu.nix
    ../../modules/hardware/face-recognition.nix
    ../../modules/hardware/asus.nix
    ../../modules/hardware/touchpad.nix
  ];

  networking.hostName = "ASUS-UX434FL";

  boot.kernelParams = [
    "i915.enable_psr=0"
    "btusb.enable_autosuspend=0"
  ];

  hardware.nvidia = {
    open = lib.mkForce false;
    package = lib.mkForce config.boot.kernelPackages.nvidiaPackages.legacy_580;
    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
      intelBusId = "PCI:0@0:2:0";
      nvidiaBusId = "PCI:2@0:0:0";
    };
  };

  swapDevices = lib.mkForce [
    {
      device = "/var/lib/swapfile";
      size = 12 * 1024;
      priority = 0;
    }
  ];

  services.gaze = {
    package = gazeOpenVINO;
    settings = {
      inference = {
        execution_provider = "openvino";
        device = "cpu";
      };
      cameras.ir = "/dev/video2";
    };
  };
}
