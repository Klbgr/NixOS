{ config, pkgs, ... }:

{
  virtualisation.docker = {
    enable = true;
  };

  environment.systemPackages = with pkgs; [
    (winboat.overrideAttrs {
      makeCacheWritable = "true";
      npmFlags = [ "--legacy-peer-deps" ];
    })
  ];
}
