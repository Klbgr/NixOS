{ pkgs, ... }:

{
  programs.gamemode = {
    enable = true;
    settings = {
      custom = {
        start = "${pkgs.systemd}/bin/systemctl stop ananicy-cpp";
        end = "${pkgs.systemd}/bin/systemctl start ananicy-cpp";
      };
    };
  };

  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
      if (
        action.id === "org.freedesktop.systemd1.manage-units" &&
        action.lookup("unit") === "ananicy-cpp.service" &&
        subject.isInGroup("gamemode")
      ) {
        return polkit.Result.YES;
      }
    });
  '';
}
