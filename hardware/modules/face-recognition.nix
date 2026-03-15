{ config, pkgs, ... }:

let
  unstableSrc = builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz";
  };

  unstablePkgs = import unstableSrc {
    inherit (pkgs) system;
    config = config.nixpkgs.config;
  };
in
{
  imports = [
    "${unstableSrc}/nixos/modules/services/security/howdy/default.nix"
  ];

  services.howdy = {
    enable = true;
    package = unstablePkgs.howdy;
    control = "sufficient";
    settings.core = {
      no_confirmation = true;
      detection_notice = true;
    };
  };

  security.pam.services =
    let
      howdy_pam_module = "${unstablePkgs.howdy}/lib/security/pam_howdy.so";
      howdyRule = {
        order = 1;
        control = "sufficient";
        modulePath = howdy_pam_module;
      };
    in
    {
      sudo.rules.auth.howdy = howdyRule;
      login.rules.auth.howdy = howdyRule;
      system-auth.rules.auth.howdy = howdyRule;
      system-local-login.rules.auth.howdy = howdyRule;
      polkit-1.rules.auth.howdy = howdyRule;
      sddm.rules.auth.howdy = howdyRule;
      gdm-password.rules.auth.howdy = howdyRule;
      kde.rules.auth.howdy = howdyRule;
      screenlocker.rules.auth.howdy = howdyRule;
      swaylock.rules.auth.howdy = howdyRule;
      hyprlock.rules.auth.howdy = howdyRule;
    };
}
