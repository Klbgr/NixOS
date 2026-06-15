{ pkgs, lib, ... }:
let
  systems = {
    PS3 = {
      collection = "PlayStation 3";
      shortname = "ps3";
      launch = "rpcs3 --no-gui --fullscreen \"{file.path}\"";
      extensions = "iso";
    };
    DS = {
      collection = "Nintendo DS";
      shortname = "nds";
      launch = "melonDS -f \"{file.path}\"";
      extensions = "nds";
    };
    Switch = {
      collection = "Nintendo Switch";
      shortname = "switch";
      launch = "ryujinx \"{file.path}\"";
      extensions = "nsp, xci";
    };
    Wii = {
      collection = "Nintendo Wii";
      shortname = "wii";
      launch = "dolphin-emu -b -e \"{file.path}\"";
      extensions = "iso, wbfs";
    };
  };

  metadataFiles = lib.mapAttrs (
    name: cfg:
    pkgs.writeText "metadata.txt" ''
      collection: ${cfg.collection}
      shortname: ${cfg.shortname}
      launch: ${cfg.launch}
      extensions: ${cfg.extensions}
      files: *
    ''
  ) systems;
in
{
  home-manager.users.antoine =
    { pkgs, ... }:

    {
      home.packages = with pkgs; [
        pegasus-frontend
      ];

      xdg.configFile."pegasus-frontend/game_dirs.txt".text = lib.strings.concatStringsSep "\n" (
        map (name: "/games/${name}") (lib.attrNames systems)
      );
    };

  systemd.tmpfiles.rules = lib.flatten (
    lib.mapAttrsToList (name: file: [
      "d /games/${name} 0775 root users -"
      "C /games/${name}/metadata.txt 0664 root users - ${file}"
    ]) metadataFiles
  );
}
