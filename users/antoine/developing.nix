{ pkgs, ... }:

{
  home.packages = with pkgs; [
    nvtopPackages.full
    wget
    nixfmt
    mamba-cpp
  ];

  programs = {
    htop = {
      enable = true;
    };
    gcc = {
      enable = true;
    };
    git = {
      enable = true;
    };
    vscode = {
      enable = true;
    };
  };
}
