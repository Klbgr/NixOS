{
  inputs,
  lib,
  ...
}:

{
  imports = [
    ./common.nix
    inputs.home-manager.nixosModules.home-manager
    ../modules/software/kde.nix
    ../modules/software/logitech.nix
    ../modules/software/cachyos-kernel.nix
    ../modules/software/lanzaboote.nix
    ../modules/software/low-latency-layer.nix
    ../users/antoine/configuration.nix
  ];

  # specialisation.noctalia.configuration = {
  #   services.desktopManager.plasma6.enable = lib.mkForce false;
  #   imports = [ ./software/noctalia.nix ];
  # };

  # Bootloader.
  boot = {
    consoleLogLevel = 0;
    initrd.verbose = false;
    kernelModules = [ "ntsync" ];
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
    binfmt.emulatedSystems = [ "aarch64-linux" ];
  };

  # Enable CUPS to print documents.
  services.printing = {
    enable = true;
    cups-pdf.enable = true;
  };

  home-manager = {
    useGlobalPkgs = true;
    backupFileExtension = "backup";
    extraSpecialArgs = { inherit inputs; };
  };

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  security.polkit.enable = true;

  services.power-profiles-daemon.enable = true;

  services.upower.enable = true;

  systemd.oomd.enable = lib.mkForce false;
  services.nohang = {
    enable = true;
    configPath = "desktop";
  };

  fileSystems."/games" = {
    device = "/dev/disk/by-label/games";
    fsType = "ext4";
  };

  systemd.tmpfiles.rules = [
    "d /games 0775 root users -"
  ];
}
