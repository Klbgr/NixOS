{ ... }:

{
  imports = [
    ./modules/kde.nix
    ./modules/kde-themes/material-you.nix
    ./modules/accounts.nix
    ./modules/samba.nix
    ./modules/programs.nix
    ./modules/developing.nix
    ./modules/gaming.nix
    ./modules/virtualisation.nix
  ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.antoine = {
    uid = 1000;
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

  home-manager.users.antoine = {
    programs.bash = {
      enable = true;
    };

    xdg.userDirs = {
      enable = true;
      createDirectories = true;
    };

    # The state version is required and should stay at the version you
    # originally installed.
    home = {
      stateVersion = "25.11";
    };
  };
}
