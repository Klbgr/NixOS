{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    (where-is-my-sddm-theme.override {
      themeConfig.General = {
        # Password mask character
        passwordCharacter = "*";
        # Mask password characters or not ("true" or "false")
        passwordMask = true;
        # value "1" is all display width, "0.5" is a half of display width etc.
        passwordInputWidth = 0.5;
        # Background color of password input
        # nord2
        passwordInputBackground = "#434c5e";
        # Radius of password input corners
        passwordInputRadius = 40;
        # Width of the border for the password input
        passwordInputBorderWidth = 0;
        # Border color for the password input
        passwordInputBorderColor = "";
        # "true" for visible cursor, "false"
        passwordInputCursorVisible = true;
        # Font size of password (in points)
        passwordFontSize = 64;
        # nord10
        passwordCursorColor = "#81a1c1";
        passwordTextColor = "";
        # Allow blank password (e.g., if authentication is done by another PAM module)
        passwordAllowEmpty = false;

        # Radius of the border which is displayed upon wrong authentication attempt
        wrongPasswordBorderRadius = "";
        # Color of the border which is displayed upon wrong authentication attempt
        # nord11
        wrongPasswordBorderColor = "#bf616a";

        # Enable or disable cursor blink animation ("true" or "false")
        cursorBlinkAnimation = true;

        # Show or not sessions choose label
        showSessionsByDefault = false;
        # Font size of sessions choose label (in points).
        sessionsFontSize = 24;

        # Show or not users choose label
        showUsersByDefault = true;
        # Font size of users choose label (in points)
        usersFontSize = 48;
        # Show user real name on label by default
        showUserRealNameByDefault = true;

        # Path to background image
        background = "";
        # Or use just one color
        # nord0
        backgroundFill = "#2e3440";
        # Fill mode for image background
        # Value must be on of: aspect, fill, tile, pad
        backgroundFillMode = "aspect";

        # Default text color for all labels
        # nord9
        basicTextColor = "#81a1c1";

        # Blur radius for background image
        blurRadius = 0;

        # Hide cursor
        hideCursor = false;

        # Default font
        font = "monospace";

        # Font of help message
        helpFont = "monospace";
        # Font size of help message (in points)
        helpFontSize = 18;
      };
    })
  ];

  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    autoNumlock = true;
    theme = "where_is_my_sddm_theme";
  };

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  services.desktopManager.plasma6.enable = true;

  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    khelpcenter
    elisa
  ];

  services.xserver.excludePackages = with pkgs; [ xterm ];

  programs.kdeconnect.enable = true;
}
