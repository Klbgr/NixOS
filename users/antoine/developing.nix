{ pkgs, ... }:

{
  home.packages = with pkgs; [
    nvtopPackages.full
    wget
    nixfmt
    conda
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
