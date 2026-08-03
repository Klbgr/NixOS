{ ... }:

{
  imports = [
    ./kde
    ./programs
    ./developing
    ./gaming
    ./virtualization
    ./samba.nix
  ];

  # specialisation.noctalia.configuration = {
  #   disabledModules = [ ./kde ];
  #   imports = [ ./noctalia ];
  # };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.antoine = {
    uid = 1000;
    isNormalUser = true;
    description = "Antoine";
    initialPassword = "antoine";
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

  home-manager.users.antoine =
    { config, ... }:

    {
      programs.bash = {
        enable = true;
        shellAliases = {
          rebuild = "sudo nixos-rebuild switch --flake /etc/nixos/";
          dry-build = "sudo nixos-rebuild dry-build --flake /etc/nixos/";
          configure = "code /etc/nixos";
          clean = "sudo nix-collect-garbage -d && nix-collect-garbage -d && nix-store --optimise";
          rebuild-yxorp = "nixos-rebuild switch --flake /etc/nixos/#YXORP --target-host yxorp@yxorp.local --build-host yxorp@yxorp.local --sudo --ask-sudo-password";
          apply-theme = "${config.home.homeDirectory}/.local/share/plasma-manager/run_all.sh";
        };
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
