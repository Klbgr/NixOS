{ ... }:

{
  imports = [
    ./kde
    ./programs
    ./developing
    ./gaming
    ./virtualisation
    ./samba.nix
  ];

  specialisation.noctalia.configuration = {
    disabledModules = [ ./kde ];
    imports = [ ./noctalia ];
  };

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
      "video"
      "render"
      "ydotool"
      "gamemode"
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
