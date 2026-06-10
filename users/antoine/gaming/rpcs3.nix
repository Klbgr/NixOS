{ ... }:

{
  home-manager.users.antoine =
    { pkgs, ... }:
    let
      pinnedPkgs = import (fetchTarball {
        url = "https://github.com/NixOS/nixpkgs/archive/1b06bb58c32597211752f4775e14b243485a374d.tar.gz";
        sha256 = "0mjx7fd8g3f8ayshaaq9xwb43kgizgqp9wnll8f2kdrq0fawxrbc";
      }) { inherit (pkgs) system; };
    in
    {
      home.packages = with pkgs; [
        (symlinkJoin {
          name = "rpcs3-with-mangohud";
          paths = [ pinnedPkgs.rpcs3 ];
          nativeBuildInputs = [ makeWrapper ];
          postBuild = ''
            wrapProgram $out/bin/rpcs3 \
              --run "${mangohud}/bin/mangohud ${pinnedPkgs.rpcs3}/bin/rpcs3"
          '';
        })
      ];
    };
}
