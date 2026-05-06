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
          hash = "sha256-3IVYWT+tXH1NpqHspi+EM+OH2MQR9SzSKXF2euEqP3M=";
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
