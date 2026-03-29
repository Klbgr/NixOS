{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    brightnessctl
    swayidle
  ];

  systemd.user.services.auto-keyboard-backlight = {
    description = "Auto-toggle keyboard backlight on idle";
    wantedBy = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    serviceConfig = {
      ExecStart = ''
        ${pkgs.swayidle}/bin/swayidle -w \
          timeout 30 '${pkgs.brightnessctl}/bin/brightnessctl --device="*::kbd_backlight" set 0 -s' \
          resume '${pkgs.brightnessctl}/bin/brightnessctl --device="*::kbd_backlight" -r'
      '';
      Restart = "always";
    };
  };
}
