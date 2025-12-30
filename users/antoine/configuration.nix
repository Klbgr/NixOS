{ config, pkgs, ... }:

{
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.antoine = {
    isNormalUser = true;
    description = "Antoine";
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
      "input"
      "ydotool"
    ];
    packages = with pkgs; [
    ];
  };

  home-manager.users.antoine =
    { pkgs, ... }:
    {
      imports = [
        ./kde.nix
      ];

      # The state version is required and should stay at the version you
      # originally installed.
      home.stateVersion = "25.11";
    };
}
