{ pkgs, ... }:

{
  services.thermald.enable = true;

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      intel-vaapi-driver
      vpl-gpu-rt
    ];
  };

  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "iHD";
  };

  services.udev.extraRules = ''
    SUBSYSTEM=="powercap", ACTION=="add", KERNEL=="intel-rapl*", RUN+="${pkgs.coreutils}/bin/chmod -R a+r /sys/class/powercap/intel-rapl"
  '';

  hardware.intel-gpu-tools.enable = true;
}
