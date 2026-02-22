{ ... }:

{
  home-manager.users.antoine =
    { pkgs, ... }:
    let
      wallpaper = "${pkgs.kdePackages.plasma-workspace-wallpapers}/share/wallpapers/ScarletTree/";
    in
    {
      home.packages = with pkgs; [
        (catppuccin-kde.override {
          flavour = [
            "latte"
            "mocha"
          ];
          accents = [ "lavender" ];
          winDecStyles = [
            "modern"
          ];
        })
        (catppuccin-kvantum.override {
          variant = "latte";
          accent = "lavender";
        })
        (catppuccin-kvantum.override {
          variant = "mocha";
          accent = "lavender";
        })
        catppuccin-cursors.latteLavender
        catppuccin-cursors.mochaLavender
        catppuccin-papirus-folders
      ];

      qt = {
        style.name = "kvantum";
        kde.settings."Kvantum/kvantum.kvconfig".General.theme = "catppuccin-latte-lavender";
      };

      programs = {
        # konsole.profiles.custom.colorScheme = "";
        plasma = {
          kscreenlocker.appearance.wallpaper = wallpaper;
          workspace = {
            colorScheme = "CatppuccinLatteLavender";
            cursor.theme = "catppuccin-latte-lavender-cursors";
            iconTheme = "Papirus";
            splashScreen.theme = "Catppuccin-Latte-Lavender";
            # theme = "";
            wallpaper = wallpaper;
            windowDecorations = {
              library = "org.kde.kwin.aurorae";
              theme = "__aurorae__svg__CatppuccinLatte-Modern";
            };
          };
        };
      };
    };
}
