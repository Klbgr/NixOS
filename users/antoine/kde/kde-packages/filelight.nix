{ ... }:

{
  home-manager.users.antoine =
    { pkgs, ... }:

    {
      home.packages = with pkgs; [
        kdePackages.filelight
      ];

      xdg.configFile.filelightrc.text = ''
        [filelight_part]
        contrast=75
        scanAcrossMounts=false
        scanRemoteMounts=false
        scheme=1
        showFoldersSidebar=true
        showSmallFiles=false
        skipList=/dev,/proc,/sys,/root,/mnt,/games
      '';
    };
}
