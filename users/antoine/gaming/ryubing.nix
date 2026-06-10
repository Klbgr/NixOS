{ ... }:

{
  home-manager.users.antoine =
    { pkgs, ... }:

    {
      home.packages = with pkgs; [
        (symlinkJoin {
          name = "ryujinx-with-gamemoderun-mangohud";
          paths = [ ryubing ];
          nativeBuildInputs = [ makeWrapper ];
          postBuild = ''
            wrapProgram $out/bin/ryujinx \
              --run "${gamemode}/bin/gamemoderun ${mangohud}/bin/mangohud ${ryubing}/bin/ryujinx; exit 0"
          '';
        })
      ];
    };
}
