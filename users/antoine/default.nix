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
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDDk16ODbH/X2/rqe8hfD0BaPtxf/v3FWsaZRStotp06 qiuantoine@gmail.com" # MSI-PRO-Z690-A
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMt2Ol4CQtB3Sg2dwgRv/XG2ybSzQDUzswsWUY6nBEwF qiuantoine@gmail.com" # ASUS-UX434FL
    ];
  };

  nix = {
    buildMachines = [
      {
        hostName = "msi-pro-z690-a.local";
        sshUser = "antoine";
        sshKey = "/home/antoine/.ssh/id_ed25519";
        publicHostKey = "c3NoLWVkMjU1MTkgQUFBQUMzTnphQzFsWkRJMU5URTVBQUFBSUFDa2JvdU9zOXUzQzEzWUFQNnd1bHEvVjZpam1uOHJ5U2VBK3ZUQTNqOEwgcm9vdEBNU0ktUFJPLVo2OTAtQQo=";
        systems = [
          "x86_64-linux"
          "aarch64-linux"
        ];
        maxJobs = 24;
        speedFactor = 2;
        supportedFeatures = [
          "nixos-test"
          "benchmark"
          "big-parallel"
          "kvm"
        ];
        mandatoryFeatures = [ ];
      }
    ];
  };

  nix.distributedBuilds = true;

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
