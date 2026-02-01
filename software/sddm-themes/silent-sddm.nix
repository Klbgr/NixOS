{ pkgs, ... }:
let
  silent-sddm-theme = pkgs.stdenv.mkDerivation rec {
    pname = "silent-sddm-theme";
    version = "main";
    src = pkgs.fetchFromGitHub {
      owner = "uiriansan";
      repo = "SilentSDDM";
      rev = version;
      sha256 = "sha256-WeoJBj/PhqFCCJEIycTipqPbKm5BpQT2uzFTYcYZ30I=";
    };
    localConfig = /etc/nixos/software/sddm-themes/silent-sddm;
    installPhase = ''
      mkdir -p $out/share/sddm/themes/silent_sddm

      cp -r ./* $out/share/sddm/themes/silent_sddm
      cp -r ${localConfig}/* $out/share/sddm/themes/silent_sddm/
    '';
  };
in
{
  environment.systemPackages = with pkgs; [
    kdePackages.qtsvg
    kdePackages.qtvirtualkeyboard
    kdePackages.qtmultimedia
    silent-sddm-theme
  ];

  services.displayManager.sddm.theme = "silent_sddm";
}
