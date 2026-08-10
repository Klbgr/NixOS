{ ... }:

{
  fileSystems =
    let
      commonOptions = [
        "x-systemd.automount"
        "noauto"
        "x-systemd.idle-timeout=60"
        "credentials=/var/lib/secrets/samba"
        "uid=1000"
        "gid=100"
        "dir_mode=0700"
        "file_mode=0600"
        "nofail"
      ];
    in
    builtins.listToAttrs (
      map
        (name: {
          name = "/mnt/antoine/${name}";
          value = {
            device = "//192.168.0.4/${name}";
            fsType = "cifs";
            options = commonOptions;
          };
        })
        [
          "data"
          "docker"
          "home_assistant"
        ]
    );
}
