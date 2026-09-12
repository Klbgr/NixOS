{ ... }:

{
  programs.gpu-screen-recorder.enable = true;

  home-manager.users.antoine =
    { pkgs, ... }:

    {
      home.packages = with pkgs; [
        gpu-screen-recorder-gtk
      ];
    };
}
