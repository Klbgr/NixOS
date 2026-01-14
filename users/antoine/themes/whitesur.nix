{ pkgs, ... }:

{
  home.packages = with pkgs; [
    whitesur-kde
    whitesur-cursors
    whitesur-icon-theme
  ];

  qt = {
    style.name = "kvantum";
    kde.settings."Kvantum/kvantum.kvconfig".General.theme = "WhiteSur";
  };

  programs = {
    # konsole.profiles.custom.colorScheme = "";
    plasma = {
      kscreenlocker.appearance.wallpaper = "${pkgs.whitesur-kde}/share/wallpapers/WhiteSur/";
      workspace = {
        colorScheme = "WhiteSurAlt";
        cursor.theme = "WhiteSur Cursors";
        iconTheme = "WhiteSur";
        splashScreen.theme = "com.github.vinceliuice.WhiteSur-alt";
        theme = "WhiteSur-alt";
        wallpaper = "${pkgs.whitesur-kde}/share/wallpapers/WhiteSur/";
        windowDecorations = {
          library = "org.kde.kwin.aurorae";
          theme = "__aurorae__svg__WhiteSur";
        };
      };
    };
  };
}
