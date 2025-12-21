{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    wget
    git
    htop
    vscode
    gcc
    nixfmt
    mamba-cpp
  ];
}
