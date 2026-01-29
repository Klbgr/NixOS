{ pkgs, ... }:

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
        "minimizeonclose@rsjtdrjgfuzkfg.com" = {
          installation_mode = "force_installed";
          install_url = "https://addons.thunderbird.net/thunderbird/downloads/latest/minimize-on-close/addon-987716-latest.xpi";
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
      };
    };
  };
}
