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
            help="Output directory for metadata file",
        )
        args = parser.parse_args()

        if not args.library_json.exists():
            print(f"Error: Could not find Heroic library at {args.library_json}")
            exit(0)

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

  run-steam-game = pkgs.writeShellScriptBin "run-steam-game" ''
    id=$1
    steam -silent steam://rungameid/"$id" &
    while ! tail -f -n 0 "$HOME/.local/share/Steam/logs/console_log.txt" | grep -q "Game process removed: AppID $id"
    do
      sleep 0.1
    done
  '';

  steam-to-pegasus = pkgs.writers.writePython3Bin "steam-to-pegasus" { } ''
    import argparse
    from pathlib import Path
    import re
    import sys


    def parse_acf(acf_path):
        try:
            content = acf_path.read_text(encoding="utf-8", errors="ignore")
            appid_match = re.search(r'"appid"\s+"([^"]+)"', content)
            name_match = re.search(r'"name"\s+"([^"]+)"', content)
            if appid_match and name_match:
                return appid_match.group(1), name_match.group(1)
        except Exception as e:
            print(
                f"Warning: Could not parse {acf_path.name}: {e}",
                file=sys.stderr
            )

        return None, None


    def main():
        parser = argparse.ArgumentParser(
            description="Convert Steam .acf files to Pegasus metadata."
        )
        parser.add_argument(
            "acf_dir",
            type=Path,
            help="Path to Steam steamapps directory containing .acf files"
        )
        parser.add_argument(
            "output_dir",
            type=Path,
            help="Output directory for metadata file",
        )
        args = parser.parse_args()

        if not args.acf_dir.exists() or not args.acf_dir.is_dir():
            print(
                f"Error: Could not find Steam directory at {args.acf_dir}",
                file=sys.stderr
            )
            sys.exit(0)

        args.output_dir.mkdir(parents=True, exist_ok=True)

        LAUNCH_CMD = "run-steam-game {file.name}"
        metadata = [
            "collection: Steam",
            f"launch: {LAUNCH_CMD}\n"
        ]

        acf_files = list(args.acf_dir.glob("appmanifest_*.acf"))
        print(f"Found {len(acf_files)} .acf files. Processing...")

        BLACKLIST = [
            "Proton",
            "Steam Linux Runtime",
            "SteamVR",
            "Steamworks Shared"
        ]

        for acf_path in acf_files:
            appid, name = parse_acf(acf_path)

            if not appid or not name:
                continue

            if any(blacklist_item in name for blacklist_item in BLACKLIST):
                continue

            metadata.append(f"game: {name}")
            metadata.append(f"file: {appid}\n")

        output_path = args.output_dir / "metadata.pegasus.txt"
        output_path.unlink(missing_ok=True)
        with open(output_path, "w", encoding="utf-8") as f:
            f.write("\n".join(metadata))

        print(f"Pegasus metadata successfully written to {output_path}")


    if __name__ == "__main__":
        main()
  '';

  scraperScript = pkgs.writeShellScript "pegasus-scraper" ''
    echo "Starting automated Pegasus setup and scraping run..."

    echo -e "\n--- Processing Steam ---"

    ${steam-to-pegasus}/bin/steam-to-pegasus /games/SteamLibrary/steamapps /games/SteamLibrary

    echo -e "\n--- Processing Heroic ---"

    ${heroic-to-pegasus}/bin/heroic-to-pegasus /home/antoine/.config/heroic/sideload_apps/library.json /games/Heroic

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

        # Default metadata header if scraper completely failed
        if [ ! -s "$SYSTEM_DIR/metadata.pegasus.txt" ]; then
          cat << 'EOF' > $SYSTEM_DIR/metadata.pegasus.txt
        collection: ${cfg.collection}
        shortname: ${cfg.shortname}
        launch: ${cfg.launch}
        extensions: ${cfg.extensions}
        ignore-regex: .*[/\\]DLC[/\\].*
        EOF
        fi
      '') systems
    )}

    echo "Scraping configuration cycle completed successfully."
  '';
in
{
  home-manager.users.antoine =
    { pkgs, config, ... }:
    let
      gameOS-theme = pkgs.stdenv.mkDerivation rec {
        pname = "gameOS-theme";
        version = "master";
        src = pkgs.fetchFromGitHub {
          owner = "PlayingKarrde";
          repo = "gameOS";
          rev = version;
          sha256 = "sha256-EBpIe0aw1FO7DzB6F3oAWD5FRLF2iZGtOHllMxuamdc=";
        };
        installPhase = ''
          mkdir -p $out/share/pegasus-frontend/themes/gameOS

          cp -r ./* $out/share/pegasus-frontend/themes/gameOS/
        '';
      };
    in
    {
      home.packages = with pkgs; [
        pegasus-frontend
        skyscraper
        run-steam-game
        gameOS-theme
      ];

      xdg.configFile = {
        "pegasus-frontend/settings.txt".text = ''
          general.theme: ${config.home.homeDirectory}/.nix-profile/share/pegasus-frontend/themes/gameOS/
          general.verify-files: false
          general.input-mouse-support: true
          general.fullscreen: true
          providers.pegasus_media.enabled: true
          providers.steam.enabled: false
          providers.gog.enabled: false
          providers.es2.enabled: false
          providers.logiqx.enabled: false
          providers.lutris.enabled: false
          providers.skraper.enabled: false
          keys.page-up: PgUp,GamepadL2
          keys.page-down: PgDown,GamepadR2
          keys.prev-page: Q,A,GamepadL1
          keys.next-page: E,D,GamepadR1
          keys.menu: F1,GamepadStart
          keys.filters: F,GamepadY
          keys.details: I,GamepadX
          keys.cancel: Esc,Backspace,GamepadB
          keys.accept: Return,Enter,GamepadA
        '';
        "pegasus-frontend/game_dirs.txt".text = lib.strings.concatStringsSep "\n" (
          (map (name: "/games/${name}") (lib.attrNames systems))
          ++ [
            "/games/Heroic"
            "/games/SteamLibrary"
          ]
        );
      };
    };

  systemd.services.pegasus-scraper = {
    description = "Pegasus scraper loop for local emulation platforms";
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = scraperScript;
      Restart = "no";
    };
  };
}
