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
  };

  home-manager.users.antoine =
    { pkgs, ... }:
    {
      imports = [
        ./accounts.nix
        ./kde.nix
        ./programs.nix
        ./developing.nix
      ];

      # The state version is required and should stay at the version you
      # originally installed.
      home.stateVersion = "25.11";
    };
}
