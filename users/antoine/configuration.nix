{ config, pkgs, ... }:
let
  uid = 1000;
in
{
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.antoine = {
    uid = uid;
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

  fileSystems =
    let
      commonOptions = [
        "x-systemd.automount"
        "noauto"
        "x-systemd.idle-timeout=60"
        "credentials=/etc/nixos/users/antoine/smb-secrets"
        "uid=${builtins.toString uid}"
        "gid=100"
        "dir_mode=0700"
        "file_mode=0600"
        "nofail"
      ];
    in
    builtins.listToAttrs (
      map
        (name: {
          name = "/mnt/antoine/${name}";
          value = {
            device = "//192.168.0.4/${name}";
            fsType = "cifs";
            options = commonOptions;
          };
        })
        [
          "data"
          "docker"
          "home_assistant"
        ]
    );

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
