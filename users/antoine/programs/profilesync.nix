{ ... }:

{
  home-manager.users.antoine =
    { pkgs, ... }:
    let
      profilesync = pkgs.python3Packages.buildPythonApplication rec {
        pname = "profilesync";
        version = "main";
        src = pkgs.fetchFromGitHub {
          owner = "duke8253";
          repo = "slicer_profile_sync_tool";
          rev = version;
          hash = "sha256-HvISwa7Kn4G+HBBKUTjnMAOVE9dXjxEj1v1dt6TIXgM=";
        };
        format = "other";
        propagatedBuildInputs = with pkgs.python3Packages; [
          colorama
          textual
        ];
        postPatch = ''
          substituteInPlace profilesync/config.py --replace-warn 'SCRIPT_DIR = Path(__file__).parent.parent.resolve()  # Go up to project root' 'SCRIPT_DIR = Path.home() / ".config" / "profilesync"' \
        '';
        installPhase = ''
          mkdir -p $out/bin $out/${pkgs.python3.sitePackages}
          cp -r profilesync $out/${pkgs.python3.sitePackages}/
          cp profilesync.py $out/bin/profilesync
          chmod +x $out/bin/profilesync
        '';
      };
    in
    {
      home.packages = with pkgs; [
        profilesync
      ];
    };
}
