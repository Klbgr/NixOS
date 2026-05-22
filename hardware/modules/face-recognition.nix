{ ... }:

{
  services.howdy = {
    enable = true;
    control = "sufficient";
    settings.core = {
      no_confirmation = true;
      detection_notice = true;
      workaround = "native";
    };
  };

  security.pam.howdy.enable = true;
}
