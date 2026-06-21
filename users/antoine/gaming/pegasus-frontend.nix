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

        output_path = args.output_dir / "metadata.pegasus.txt"
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

  scraperScript = pkgs.writeShellScript "pegasus-scraper" ''
    set -e
    echo "Starting automated Pegasus setup and scraping run..."

    ${lib.concatStringsSep "\n" (
      lib.mapAttrsToList (name: cfg: ''
        echo -e "\n--- Processing ${name} (${cfg.shortname}) ---"

        SYSTEM_DIR=/games/${name}

        # Ensure game directory exists safely
        mkdir -p $SYSTEM_DIR/Games

        # Retain explicit permissions: owner=root, group=users, mode=0775
        chown root:users $SYSTEM_DIR
        chmod 0775 $SYSTEM_DIR
        chown root:users $SYSTEM_DIR/Games
        chmod 0775 $SYSTEM_DIR/Games

        # Write core structural metadata header if the file doesn't exist or is empty
        if [ ! -s "$SYSTEM_DIR/metadata.pegasus.txt" ]; then
          cat << 'EOF' > $SYSTEM_DIR/metadata.pegasus.txt
        collection: ${cfg.collection}
        shortname: ${cfg.shortname}
        launch: ${cfg.launch}
        extensions: ${cfg.extensions}
        ignore-regex: .*[/\\]DLC[/\\].*
        EOF
        fi

        # Set permissions for the metadata file to match your original tmpfiles layout (0664)
        chown root:users $SYSTEM_DIR/metadata.pegasus.txt
        chmod 0664 $SYSTEM_DIR/metadata.pegasus.txt

        # Gather metadata into Skyscraper local cache
        ${pkgs.skyscraper}/bin/Skyscraper -p ${cfg.shortname} -s screenscraper -i $SYSTEM_DIR/Games --region eu --lang fr

        # Generate asset metadata list file specifically targets metadata.pegasus.txt
        ${pkgs.skyscraper}/bin/Skyscraper -p ${cfg.shortname} -f pegasus -i $SYSTEM_DIR/Games -g $SYSTEM_DIR --region eu --lang fr --flags unattend
      '') systems
    )}

    echo "Scraping configuration cycle completed successfully."
  '';
in
{
  home-manager.users.antoine =
    { pkgs, ... }:

    {
      home.packages = with pkgs; [
        pegasus-frontend
        skyscraper
      ];

      xdg.configFile."pegasus-frontend/game_dirs.txt".text = lib.strings.concatStringsSep "\n" (
        (map (name: "/games/${name}") (lib.attrNames systems)) ++ [ "/games/Heroic" ]
      );
    };

  systemd.services.pegasus-scraper = {
    description = "Pegasus scraper loop for local emulation platforms";
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = scraperScript;
      Restart = "on-failure";
      RestartSec = 30;
      StartLimitBurst = 5;
    };
  };
}
