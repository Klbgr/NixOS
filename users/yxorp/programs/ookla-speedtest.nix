{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    ookla-speedtest
  ];
}
