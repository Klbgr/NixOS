# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ pkgs, lib, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    # ./hardware/msi-pro-z690-a.nix
    ./hardware/asus-ux434fl.nix
    ./software/kde.nix
    ./software/logitech.nix
    ./software/cachyos-kernel.nix
    ./software/lanzaboote.nix
    ./software/modules/home-manager.nix
    ./users/antoine/configuration.nix
    ./utils
  ];

  specialisation.noctalia.configuration = {
    services.desktopManager.plasma6.enable = lib.mkForce false;
    imports = [ ./software/noctalia.nix ];
  };

  # Bootloader.
  boot = {
    consoleLogLevel = 0;
    initrd.verbose = false;
    kernelParams = [
      "quiet"
      "udev.log_level=3"
    ];
    loader = {
      systemd-boot = {
        enable = true;
        consoleMode = "max";
      };
      efi.canTouchEfiVariables = true;
    };
    plymouth.enable = true;
  };

  # Enable networking
  networking.networkmanager.enable = true;

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

  # Configure keymap in X11
  services.xserver = {
    enable = true;
    excludePackages = with pkgs; [ xterm ];
    xkb = {
      layout = "fr,us";
      variant = "";
      options = "caps:shiftlock,grp:win_space_toggle";
    };
  };

  # Configure console keymap
  console.useXkbConfig = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

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

  home-manager = {
    useGlobalPkgs = true;
    backupFileExtension = "backup";
  };

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  services.dbus = {
    enable = true;
    implementation = "broker";
  };

  security.polkit.enable = true;

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  services.fstrim.enable = true;

  zramSwap = {
    enable = true;
    priority = 1000;
  };

  services.geoclue2.enable = true;

  services.automatic-timezoned.enable = true;

  services.fwupd.enable = true;

  services.power-profiles-daemon.enable = true;

  services.upower.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}
