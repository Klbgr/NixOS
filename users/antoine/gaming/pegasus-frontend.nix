{ pkgs, lib, ... }:
let
  heroic-to-pegasus = pkgs.writers.writePython3Bin "heroic-to-pegasus" { } ''
    import argparse
    import json
    from pathlib import Path


    def main():
        parser = argparse.ArgumentParser(
            description="Convert Heroic sideload JSON to Pegasus metadata."
        )
        parser.add_argument(
            "library_json", type=Path, help="Path to Heroic library.json"
        )
        parser.add_argument(
            "output_dir",
            type=Path,
            help="Output directory for metadata.txt",
        )
        args = parser.parse_args()

        if not args.library_json.exists():
            print(f"Error: Could not find Heroic library at {args.library_json}")
            exit(1)

        args.output_dir.mkdir(parents=True, exist_ok=True)

        with open(args.library_json, "r", encoding="utf-8") as f:
            data = json.load(f)

        LAUNCH_CMD = (
            "heroic --no-gui --no-sandbox "
            "heroic://launch?appName={file.name}&runner=sideload"
        )

        metadata = []
        metadata.append("collection: Steam")
        metadata.append(f"launch: {LAUNCH_CMD}\n")

        print(f"Parsing {len(data.get('games', []))} sideloaded entries...")

        BLACKLIST = ["Ubisoft Connect"]

        for game in data.get("games", []):
            if not game.get("is_installed", False):
                continue

            title = game.get("title")
            if title in BLACKLIST:
                continue

            app_name = game.get("app_name")

            metadata.append(f"game: {title}")
            metadata.append(f"file: {app_name}\n")

        output_path = args.output_dir / "metadata.txt"
        output_path.unlink(missing_ok=True)
        with open(output_path, "w", encoding="utf-8") as f:
            f.write("\n".join(metadata))

        print(f"Pegasus metadata successfully written to {output_path}")


    if __name__ == "__main__":
        main()
  '';

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
      ignore-regex: .*[/\\]DLC[/\\].*
    ''
  ) systems;
in
{
  home-manager.users.antoine =
    { config, pkgs, ... }:

    {
      home.packages = with pkgs; [
        heroic-to-pegasus
        (symlinkJoin {
          name = "pegasus-with-heroic-to-pegasus";
          paths = [
            (writeShellScriptBin "pegasus-fe" ''
              ${heroic-to-pegasus}/bin/heroic-to-pegasus ${config.home.homeDirectory}/.config/heroic/sideload_apps/library.json /games/Heroic
              exec ${pegasus-frontend}/bin/pegasus-fe "$@"
            '')
            pegasus-frontend
          ];
          postBuild = ''
            rm $out/share/applications/org.pegasus_frontend.Pegasus.desktop
            cp ${pegasus-frontend}/share/applications/org.pegasus_frontend.Pegasus.desktop $out/share/applications/org.pegasus_frontend.Pegasus.desktop
            chmod +w $out/share/applications/org.pegasus_frontend.Pegasus.desktop
            substituteInPlace $out/share/applications/org.pegasus_frontend.Pegasus.desktop \
              --replace-fail "${pegasus-frontend}/bin/pegasus-fe" "$out/bin/pegasus-fe"
          '';
        })
      ];

      xdg.configFile."pegasus-frontend/game_dirs.txt".text = lib.strings.concatStringsSep "\n" (
        (map (name: "/games/${name}") (lib.attrNames systems)) ++ [ "/games/Heroic" ]
      );
    };

  systemd.tmpfiles.rules = lib.flatten (
    lib.mapAttrsToList (name: file: [
      "d /games/${name} 0775 root users -"
      "L+ /games/${name}/metadata.txt 0664 root users - ${file}"
    ]) metadataFiles
  );
}
