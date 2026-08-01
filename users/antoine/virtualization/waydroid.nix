{ pkgs, ... }:

{
  home-manager.users.antoine =
    { pkgs, ... }:

    {
      home.packages = with pkgs; [
        waydroid-helper
      ];
    };

  virtualisation.waydroid.enable = true;

  systemd.services.waydroid-init = {
    description = "Declarative Waydroid GAPPS initialization and config";
    after = [ "network-online.target" ];
    requires = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = pkgs.writeShellScript "waydroid-setup" ''
        CONFIG_FILE="/var/lib/waydroid/waydroid.cfg"

        if [ ! -f "/var/lib/waydroid/images/system.img" ]; then
          echo "Initializing Waydroid GAPPS..."
          ${pkgs.waydroid}/bin/waydroid init -s GAPPS -f
        fi

        if ! grep -q "\[properties\]" "$CONFIG_FILE"; then
          echo -e "\n[properties]" >> "$CONFIG_FILE"
        fi

        set_cfg_prop() {
          if ! grep -q "^$1 =" "$CONFIG_FILE"; then
            echo "Adding $1 to config..."
            # Insert right after the [properties] header
            sed -i "/\[properties\]/a $1 = $2" "$CONFIG_FILE"
          fi
        }

        set_cfg_prop "persist.waydroid.suspend" "true"
        set_cfg_prop "persist.waydroid.multi_windows" "true"
        set_cfg_prop "persist.sys.language" "fr"
        set_cfg_prop "persist.sys.country" "FR"
        set_cfg_prop "persist.sys.locale" "fr-FR"
        set_cfg_prop "persist.sys.timezone" "Europe/Paris"

        echo "Applying configuration via offline upgrade..."
        ${pkgs.waydroid}/bin/waydroid upgrade --offline

        echo "Waydroid is fully configured."
      '';
    };
  };
}
