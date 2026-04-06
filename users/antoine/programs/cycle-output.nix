{ ... }:

{
  home-manager.users.antoine =
    { pkgs, ... }:

    {
      home.packages = [
        (pkgs.writeShellScriptBin "cycle-output" ''
          PATH=$PATH:${pkgs.wireplumber}/bin:${pkgs.gawk}/bin

          SINKS=($(wpctl status | awk '
              /Sinks:/ { in_sinks=1; next }
              in_sinks && (/Sources:/ || /^$/ || /Filters:/) { in_sinks=0; exit }
              in_sinks && /Easy Effects Sink/ { next }
              in_sinks && /[0-9]+\./ {
                  match($0, /[0-9]+\./);
                  id = substr($0, RSTART, RLENGTH - 1);
                  print id
              }
          '))

          CURRENT_SINK=$(wpctl status | awk '
              /Sinks:/ { in_sinks=1; next }
              in_sinks && (/Sources:/ || /^$/ || /Filters:/) { in_sinks=0; exit }
              in_sinks && /\*/ {
                  match($0, /[0-9]+\./);
                  print substr($0, RSTART, RLENGTH - 1);
                  exit
              }
          ')

          if [ ''${#SINKS[@]} -eq 0 ]; then
              echo "No valid audio sinks found."
              exit 1
          fi

          NEXT_SINK=""
          for i in "''${!SINKS[@]}"; do
              if [[ "''${SINKS[$i]}" == "$CURRENT_SINK" ]]; then
                  NEXT_INDEX=$(( (i + 1) % ''${#SINKS[@]} ))
                  NEXT_SINK="''${SINKS[$NEXT_INDEX]}"
                  break
              fi
          done

          if [ -z "$NEXT_SINK" ]; then
              NEXT_SINK="''${SINKS[0]}"
          fi

          wpctl set-default "$NEXT_SINK"
        '')
        (pkgs.makeDesktopItem {
          name = "cycle-output";
          desktopName = "Cycle Output";
          exec = "cycle-output";
          icon = "audio-card";
          startupNotify = false;
          categories = [ "Audio" ];
          noDisplay = true;
        })
      ];
    };
}
