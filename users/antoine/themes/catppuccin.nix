{ pkgs, ... }:

{
  home.packages = with pkgs; [
    catppuccin-kde
    catppuccin-kvantum
    catppuccin-cursors.frappeBlue
    catppuccin-papirus-folders
  ];

  qt = {
    style.name = "kvantum";
    kde.settings."Kvantum/kvantum.kvconfig".General.theme = "catppuccin-frappe-blue";
  };

  programs = {
    # konsole.profiles.custom.colorScheme = "";
    plasma = {
      kscreenlocker.appearance.wallpaper = "${pkgs.kdePackages.plasma-workspace-wallpapers}/share/wallpapers/ScarletTree/";
      workspace = {
        colorScheme = "Catppuccin Frappe Blue";
        cursor.theme = "catppuccin-frappe-blue-cursors";
        iconTheme = "Papirus";
        splashScreen.theme = "Catppuccin-Frappe-Blue";
        # theme = "";
        wallpaper = "${pkgs.kdePackages.plasma-workspace-wallpapers}/share/wallpapers/ScarletTree/";
        windowDecorations = {
          library = "org.kde.kwin.aurorae";
          theme = "__aurorae__svg__CatppuccinFrappe-Modern";
        };
      };
    };
  };
}
