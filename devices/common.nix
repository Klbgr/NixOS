{
  lib,
  pkgs,
  ...
}:

{
  imports = [ ../utils ];

  boot.binfmt.emulatedSystems = lib.filter (sys: sys != pkgs.stdenv.hostPlatform.system) [
    "x86_64-linux"
    "aarch64-linux"
  ];

  # Enable OpenGL
  hardware.graphics.enable = true;

  # Enable networking
  networking = {
    networkmanager.enable = true;
    firewall.enable = true;
  };

  # Select internationalisation properties.
  i18n.defaultLocale = "fr_FR.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "fr_FR.UTF-8";
    LC_IDENTIFICATION = "fr_FR.UTF-8";
    LC_MEASUREMENT = "fr_FR.UTF-8";
    LC_MONETARY = "fr_FR.UTF-8";
    LC_NAME = "fr_FR.UTF-8";
    LC_NUMERIC = "fr_FR.UTF-8";
    LC_PAPER = "fr_FR.UTF-8";
    LC_TELEPHONE = "fr_FR.UTF-8";
    LC_TIME = "fr_FR.UTF-8";
  };

  console.keyMap = "fr";

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  environment.variables.NIXPKGS_ALLOW_UNFREE = "1";

  time.hardwareClockInLocalTime = true;

  nix = {
    settings = {
      auto-optimise-store = true;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };
  };

  hardware.bluetooth.enable = true;

  services.dbus = {
    enable = true;
    implementation = "broker";
  };

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    nssmdns6 = true;
    openFirewall = true;
    publish = {
      enable = true;
      addresses = true;
    };
  };

  services.fstrim.enable = true;

  zramSwap = {
    enable = true;
    priority = 1000;
    memoryPercent = 100;
  };

  services.geoclue2.enable = true;

  services.automatic-timezoned.enable = true;

  services.fwupd.enable = true;

  nix.settings = {
    substituters = [
      "https://nix-community.cachix.org"
      "https://nixos-raspberrypi.cachix.org"
      "https://attic.xuyh0120.win/lantian"
    ];
    trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "nixos-raspberrypi.cachix.org-1:4iMO9LXa8BqhU+Rpg6LQKiGa2lsNh/j2oiYLNOQ5sPI="
      "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="
    ];
    trusted-users = [
      "root"
      "@wheel"
      "antoine"
    ];
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}
