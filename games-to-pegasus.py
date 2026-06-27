import re
import os
import shutil
import json
from glob import glob
import subprocess

HEROIC = "Heroic"
STEAM = "Steam"
SWITCH = "Switch"
WII = "Wii"
PS3 = "PS3"
DS = "DS"

SYSTEMS = [HEROIC, STEAM, SWITCH, WII, PS3, DS]

BLACKLISTS = {
    HEROIC: ["Ubisoft Connect", "Rockstar Games Launcher"],
    STEAM: ["Proton", "Steam Linux Runtime", "SteamVR", "Steamworks Shared"],
    SWITCH: [],
    WII: [],
    PS3: [],
    DS: [],
}

EXTENSIONS = {
    SWITCH: ["nsp", "xci"],
    WII: ["iso", "wbfs"],
    PS3: ["iso"],
    DS: ["nds"],
}

LAUNCHES = {
    STEAM: "run-steam-game \"{path}\"",
    HEROIC: (
        "heroic --no-gui --no-sandbox "
        "\"heroic://launch?appName={path}&runner=sideload\""
    ),
    SWITCH: "ryujinx \"{path}\"",
    WII: "dolphin-emu -b -e \"{path}\"",
    PS3: "rpcs3 --no-gui --fullscreen \"{path}\"",
    DS: "melonDS -f \"{path}\"",
}

PLATFORMS = {
    STEAM: "pc",
    HEROIC: "pc",
    SWITCH: "switch",
    WII: "wii",
    PS3: "ps3",
    DS: "nds",
}

DIRECTORY = "/games"


def parse_emulator(directory, extensions):
    games = []
    if isinstance(extensions, str):
        extensions = [extensions]
    globs = [
        glob(os.path.join(directory, "**", f"*.{extension}"), recursive=True)
        for extension in extensions
    ]
    raw_games = []
    for game in globs:
        raw_games.extend(game)
    for game_path in raw_games:
        game = os.path.basename(game_path)
        name, extension = os.path.splitext(game)
        if extension[1:] not in extensions:
            continue
        games.append((name, game_path))
    return games


def parse_steam(directory):
    games = []
    for acf in os.listdir(directory):
        if not acf.startswith("appmanifest_") or not acf.endswith(".acf"):
            continue
        acf_path = os.path.join(directory, acf)
        with open(acf_path, "r", encoding="utf-8", errors="ignore") as f:
            content = f.read()
        appid = re.search(r'"appid"\s+"([^"]+)"', content)
        name = re.search(r'"name"\s+"([^"]+)"', content)
        if not (appid and name):
            continue
        appid = appid.group(1)
        name = name.group(1)
        games.append((name, appid))
    return games


def parse_heroic(library_path):
    games = []
    with open(library_path, "r", encoding="utf-8", errors="ignore") as f:
        content = json.load(f)
    for game in content["games"]:
        name = game["title"]
        app_id = game["app_name"]
        games.append((name, app_id))
    return games


def set_permissions(target, directory=False):
    os.chown(target, uid=0, gid=100)
    os.chmod(target, mode=0o775 if directory else 0o664)


def main(directory, systems):
    os.makedirs(directory, exist_ok=True)
    set_permissions(directory, directory=True)
    for system in systems:
        blacklist = BLACKLISTS[system]
        launch_template = LAUNCHES[system]
        platform = PLATFORMS[system]
        if system == STEAM:
            steam_library_path = os.path.join(directory, "SteamLibrary")
            os.makedirs(steam_library_path, exist_ok=True)
            set_permissions(steam_library_path, directory=True)
            steamapps_path = os.path.join(steam_library_path, "steamapps")
            os.makedirs(steamapps_path, exist_ok=True)
            set_permissions(steamapps_path, directory=True)
            games = parse_steam(steamapps_path)
            pegasus_path = os.path.join(steam_library_path, "Pegasus")
            shutil.rmtree(pegasus_path, ignore_errors=True)
            os.makedirs(pegasus_path, exist_ok=True)
            set_permissions(pegasus_path, directory=True)
        else:
            system_path = os.path.join(directory, system)
            os.makedirs(system_path, exist_ok=True)
            set_permissions(system_path, directory=True)
            system_games_path = os.path.join(system_path, "Games")
            os.makedirs(system_games_path, exist_ok=True)
            set_permissions(system_games_path, directory=True)
            if system == HEROIC:
                games = parse_heroic(
                    "/home/antoine/.config/heroic/sideload_apps/library.json"
                )
            else:
                extensions = EXTENSIONS[system]
                games = parse_emulator(system_games_path, extensions)
            pegasus_path = os.path.join(directory, system, "Pegasus")
            shutil.rmtree(pegasus_path, ignore_errors=True)
            os.makedirs(pegasus_path, exist_ok=True)
            set_permissions(pegasus_path, directory=True)

        for game_name, game_path in games:
            if game_name in blacklist:
                continue
            skip = False
            for blacklist_item in blacklist:
                if blacklist_item in game_name:
                    skip = True
                    break
            if skip:
                continue
            pegasus_game_path = os.path.join(pegasus_path, f"{game_name}.sh")
            with open(pegasus_game_path, "w", encoding="utf-8") as f:
                f.write(launch_template.format(path=game_path))
            set_permissions(pegasus_game_path)

        pc = system in [HEROIC, STEAM]
        metadata_path = os.path.join(pegasus_path, "metadata.pegasus.txt")
        metadata = "\n".join(
            [
                f"collection: {'PC' if pc else system}",
                f"shortname: {platform}",
                "extension: sh",
                "launch: bash {file.path}",
            ]
        )
        with open(metadata_path, "w", encoding="utf-8") as f:
            f.write(metadata)
        set_permissions(metadata_path)

        scraper = "thegamesdb" if pc else "screenscraper"
        second_scraper = "screenscraper" if pc else "thegamesdb"
        commands = [
            f"Skyscraper -p {platform} -s {scraper} -i {pegasus_path} "
            f"--addext sh --region eu --lang fr",
            f"Skyscraper -p {platform} -s {second_scraper} -i {pegasus_path} "
            f"--addext sh --region eu --lang fr --flags onlymissing",
            f"Skyscraper -p {platform} -f pegasus -i {pegasus_path} "
            f"-g {pegasus_path} --addext sh --region eu --lang fr "
            f"--flags unattend --flags theinfront",
        ]
        for command in commands:
            print(command, flush=True)
            subprocess.run(command.split())

        is_empty = (
            not os.path.exists(metadata_path)
            or os.path.getsize(metadata_path) == 0
        )
        if is_empty:
            with open(metadata_path, "w", encoding="utf-8") as f:
                f.write(metadata)

        if pc:
            with open(metadata_path, "r", encoding="utf-8") as f:
                metadata = f.read()
            metadata = metadata.replace("shortname: pc", "shortname: windows")
            with open(metadata_path, "w", encoding="utf-8") as f:
                f.write(metadata)


if __name__ == "__main__":
    main(DIRECTORY, SYSTEMS)
