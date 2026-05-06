{ ... }:

{
  home-manager.users.antoine =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    let
      thunderbirdIcon = builtins.readFile (
        pkgs.runCommand "resized-image-b64"
          {
            nativeBuildInputs = [ pkgs.imagemagick ];
            src = pkgs.fetchurl {
              url = "https://upload.wikimedia.org/wikipedia/commons/5/53/Thunderbird_2023_icon.png";
              hash = "sha256-02hTT2pxLbOBbTit+2Cv/xKDZXj+2mnOHoe2pKvDU8U=";
            };
          }
          ''
            magick $src -resize 256x256! png:- | base64 -w 0 > $out
          ''
      );
      thunderbirdUnreadIcon = builtins.readFile (
        pkgs.runCommand "resized-image-red-dot"
          {
            nativeBuildInputs = [ pkgs.imagemagick ];
            src = pkgs.fetchurl {
              url = "https://upload.wikimedia.org/wikipedia/commons/5/53/Thunderbird_2023_icon.png";
              hash = "sha256-02hTT2pxLbOBbTit+2Cv/xKDZXj+2mnOHoe2pKvDU8U=";
            };
          }
          ''
            magick $src -resize 256x256! \
              -fill red -draw "circle 192,64 224,64" \
              png:- | base64 -w 0 > $out
          ''
      );

      profile = "${config.home.homeDirectory}/.thunderbird/Default";
      msfFiles =
        if builtins.pathExists profile then
          builtins.filter (
            path:
            lib.hasSuffix ".msf" (toString path)
            && !(builtins.elem (baseNameOf (toString path)) [
              "Spam.msf"
              "Junk.msf"
              "Corbeille.msf"
              "Trash.msf"
            ])
          ) (lib.filesystem.listFilesRecursive profile)
        else
          [ ];
      accounts = builtins.toJSON (
        map (path: {
          color = "#0000ff";
          path = toString path;
        }) msfFiles
      );
    in
    {
      accounts = {
        calendar.accounts = {
          Google = {
            primary = true;
            primaryCollection = "qiuantoine@gmail.com";
            remote = {
              type = "caldav";
              url = "https://apidata.googleusercontent.com/caldav/v2/qiuantoine@gmail.com/events/";
              userName = "qiuantoine@gmail.com";
            };
            thunderbird.enable = true;
          };
          "Jours fériés en France" = {
            primary = false;
            remote = {
              type = "caldav";
              url = "https://apidata.googleusercontent.com/caldav/v2/cpp2spjicln66q13d1nmoqb4c5sk0pridtqn0bjm5phm2r35dpi62shectnmuprcckn66rrd%40virtual/events/";
              userName = "qiuantoine@gmail.com";
            };
            thunderbird.enable = true;
          };
        };
        contact.accounts = {
          Google = {
            remote = {
              type = "carddav";
              url = "https://www.googleapis.com/carddav/v1/principals/qiuantoine@gmail.com/lists/default/";
              userName = "qiuantoine@gmail.com";
            };
            thunderbird.enable = true;
          };
        };
        email.accounts = {
          Gmail = {
            enable = true;
            address = "qiuantoine@gmail.com";
            flavor = "gmail.com";
            primary = true;
            realName = "Antoine Qiu";
            thunderbird = {
              enable = true;
              settings = id: {
                "mail.server.server_${id}.autosync_max_age_days" = 30;
                "mail.identity.id_${id}.reply_on_top" = 1;
                "mail.identity.id_${id}.sig_bottom" = false;
              };
            };
            userName = "qiuantoine@gmail.com";
          };
          Free = {
            enable = true;
            address = "qiuantoine@free.fr";
            flavor = "plain";
            imap = {
              authentication = "plain";
              host = "imap.free.fr";
              port = 993;
              tls = {
                enable = true;
                certificatesFile = null;
                useStartTls = false;
              };
            };
            primary = false;
            realName = "Antoine Qiu";
            smtp = {
              authentication = "plain";
              host = "smtp.free.fr";
              port = 587;
              tls = {
                enable = true;
                certificatesFile = null;
                useStartTls = true;
              };
            };
            thunderbird = {
              enable = true;
              settings = id: {
                "mail.server.server_${id}.autosync_max_age_days" = 30;
                "mail.identity.id_${id}.reply_on_top" = 1;
                "mail.identity.id_${id}.sig_bottom" = false;
              };
            };
            userName = "qiuantoine@free.fr";
          };
        };
      };

      programs.thunderbird = {
        enable = true;
        package = pkgs.thunderbird.override {
          extraPolicies.ExtensionSettings = {
            "langpack-fr@thunderbird.mozilla.org" = {
              installation_mode = "force_installed";
              install_url = "https://addons.thunderbird.net/thunderbird/downloads/file/1043168/francais_fr_language_pack-146.0.20251203.205047-tb.xpi";
            };
            "fr-dicollecte@dictionaries.addons.mozilla.org" = {
              installation_mode = "force_installed";
              install_url = "https://addons.thunderbird.net/thunderbird/downloads/latest/dictionnaire-fran%C3%A7ais1/addon-354872-latest.xpi";
            };
          };
        };
        profiles.Default = {
          accountsOrder = [
            "Gmail"
            "Free"
          ];
          isDefault = true;
          settings = {
            "extensions.autoDisableScopes" = 0;
            "datareporting.healthreport.uploadEnabled" = false;
            "intl.locale.requested" = "fr,en-US";
            "mail.spam.manualMark" = true;
            "mail.spam.markAsReadOnSpam" = true;
            "mailnews.headers.extraAddonHeaders" = "autocrypt openpgp";
            "mailnews.message_display.disable_remote_image" = false;
            "mailnews.start_page.enabled" = false;
            "privacy.globalprivacycontrol.enabled" = true;
            "mail.compose.default_to_paragraph" = false;
            "spellchecker.dictionary" = "en-US,fr";
            "calendar.alarms.playsound" = false;
            "calendar.alarms.show" = false;
          };
        };
      };

      home.packages = with pkgs; [
        (birdtray.overrideAttrs (oldAttrs: {
          nativeBuildInputs = (oldAttrs.nativeBuildInputs or [ ]) ++ [ makeWrapper ];
          cmakeFlags = (oldAttrs.cmakeFlags or [ ]) ++ [
            "-DOPT_THUNDERBIRD_CMDLINE=${pkgs.thunderbird}/bin/thunderbird"
          ];
          postInstall = (oldAttrs.postInstall or "") + ''
            wrapProgram $out/bin/birdtray \
              --set GDK_BACKEND "x11"
          '';
        }))
      ];

      xdg.configFile = {
        "birdtray-config.json".text = ''
          {
            "accounts": ${accounts},
            "advanced/blinkingusealpha": false,
            "advanced/forcedRereadInterval": 0,
            "advanced/ignoreNetWMhints": false,
            "advanced/ignoreUpdateVersion": "",
            "advanced/notificationfontmaxsize": 512,
            "advanced/notificationfontminsize": 4,
            "advanced/onlyShowIconOnUnreadMessages": false,
            "advanced/runProcessOnChange": "",
            "advanced/tbprocessname": "thunderbird",
            "advanced/tbwindowmatch": " Thunderbird",
            "advanced/unreadopacitylevel": 0.75,
            "advanced/updateOnStartup": false,
            "advanced/watchfiletimeout": 150,
            "common/allowsuppressingunread": false,
            "common/blinkspeed": 0,
            "common/bordercolor": "#ffffff",
            "common/borderwidth": 0,
            "common/defaultcolor": "#0000ff",
            "common/exitthunderbirdonquit": true,
            "common/forceIgnoreUnreadEmailsOnMinimize": false,
            "common/hideWhenStartedManually": true,
            "common/hidewhenminimized": true,
            "common/hidewhenrestarted": true,
            "common/hidewhenstarted": true,
            "common/ignoreShowUnreadCount": false,
            "common/ignoreStartUnreadCount": false,
            "common/launchthunderbird": true,
            "common/launchthunderbirddelay": 0,
            "common/monitorthunderbirdwindow": true,
            "common/newemailEnabled": false,
            "common/notificationfont": "Noto Sans,10,-1,0,50,0,0,0,0,0",
            "common/notificationfontweight": 50,
            "common/notificationicon": "${thunderbirdIcon}",
            "common/notificationiconunread": "${thunderbirdUnreadIcon}",
            "common/restartthunderbird": true,
            "common/showDialogIfNoAccountsConfigured": false,
            "common/showhidethunderbird": true,
            "common/showunreademailcount": false,
            "common/startClosedThunderbird": true
          }
        '';

        "autostart/Birdtray.desktop".text = ''
          [Desktop Entry]
          Type = Application
          Name = Birdtray
          Exec = birdtray
        '';
      };
    };
}
