{ pkgs, ... }:

{
  home.packages = with pkgs; [
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
