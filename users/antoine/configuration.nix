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
      "dialout"
    ];
  };

  home-manager.users.antoine = {
    programs.bash = {
      enable = true;
      shellAliases = {
        rebuild = "sudo nixos-rebuild switch --flake /etc/nixos/";
        dry-run = "sudo nixos-rebuild dry-run --flake /etc/nixos/";
        configure = "code /etc/nixos";
        clean = "sudo nix-collect-garbage -d && nix-collect-garbage -d";
        optimise = "nix-store --optimise";
      };
      initExtra = ''
        nix-checkout() {
          if [ -z "$1" ]; then
            echo "Error: Please provide a nixpkgs commit hash. See https://status.nixos.org"
            echo "Usage: nix-checkout <commit-hash>"
            return 1
          fi
          nix flake lock --override-input nixpkgs "github:nixos/nixpkgs/$1"
        }
      '';
    };

    xdg.userDirs = {
      enable = true;
      createDirectories = true;
      setSessionVariables = true;
    };

    # The state version is required and should stay at the version you
    # originally installed.
    home = {
      stateVersion = "25.11";
    };
  };
}
