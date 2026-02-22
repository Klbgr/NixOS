{ config, pkgs, ... }:

{
  hardware.logitech.wireless.enable = true;

  environment.systemPackages = with pkgs; [
    logiops
  ];

  systemd.services.logiops = {
    description = "Logiops Daemon";
    after = [ "graphical.target" ];
    wantedBy = [ "graphical.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.logiops}/bin/logid";
      Restart = "always";
    };
    enable = true;
  };

  environment.etc."logid.cfg".text = ''
    devices: (
      {
        name: "MX Master 3S";
        buttons: (
          {
            cid: 0xc3; # Gesture button
            action: {
              type: "Gestures";
              gestures: (
                {
                  direction: "Up";
                  mode: "OnInterval";
                  interval: 100;
                  action: {
                    type: "Keypress";
                    keys: ["KEY_VOLUMEUP"];
                  };
                },
                {
                  direction: "Down";
                  mode: "OnInterval";
                  interval: 100;
                  action: {
                    type: "Keypress";
                    keys: ["KEY_VOLUMEDOWN"];
                  };
                },
                {
                  direction: "Left";
                  mode: "OnRelease";
                  action: {
                    type: "Keypress";
                    keys: ["KEY_PREVIOUSSONG"];
                  };
                },
                {
                  direction: "Right";
                  mode: "OnRelease";
                  action: {
                    type: "Keypress";
                    keys: ["KEY_NEXTSONG"];
                  };
                },
                {
                  direction: "None";
                  mode: "OnRelease";
                  action: { 
                    type: "Keypress";
                    keys: ["KEY_PLAYPAUSE"];
                  };
                }
              );
            };
          },
          {
            cid: 0xc4; # Top button
            action: {
              type: "ToggleSmartShift";
            };
          }
        );
        smartshift: {
          on: true;
          threshold: 25;
        };
        hiresscroll: { 
          hires: false;
        };
        thumbwheel: {
          divert: false;
          invert: true;
        }
      },
      {
        name: "MX Keys Wireless Keyboard";
        buttons: (
          {
            cid: 0x00c7;
            action: {
              type: "Keypress";
              keys: ["KEY_BRIGHTNESSDOWN"];
            };
          },
          {
            cid: 0x00c8;
            action: {
              type: "Keypress";
              keys: ["KEY_BRIGHTNESSUP"];
            };
          }
        );
      }
    );
    io_timeout: 60000.0;
  '';
}
