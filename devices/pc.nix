{
  inputs,
  lib,
  pkgs,
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
    ../users/antoine
  ];

  # specialisation.noctalia.configuration = {
  #   services.desktopManager.plasma6.enable = lib.mkForce false;
  #   imports = [ ./software/noctalia.nix ];
  # };

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "prohibit-password";
    };
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

  # Enable OpenGL 32-bit
  hardware.graphics.enable32Bit = true;

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
    binfmt.emulatedSystems = lib.filter (sys: sys != pkgs.stdenv.hostPlatform.system) [
      "x86_64-linux"
      "aarch64-linux"
    ];
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
