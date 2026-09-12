{ ... }:

{
  home-manager.users.antoine =
    { pkgs, ... }:

    {
      home.packages = [
        (pkgs.writeShellScriptBin "capture" ''
          NAME="Elgato HD60 X"
          RESOLUTION="2560x1440"
          FPS="30"

          while [[ $# -gt 0 ]]; do
              case "$1" in
              --res|-r)
                  RESOLUTION="$2"
                  shift 2
                  ;;
              --fps|-f)
                  FPS="$2"
                  shift 2
                  ;;
              --name|-n)
                  NAME="$2"
                  shift 2
                  ;;
              *)
                  echo "Unknown option : $1" >&2
                  shift
                  ;;
              esac
          done

          VIDEO_SOURCE=$(${pkgs.v4l-utils}/bin/v4l2-ctl --list-devices | ${pkgs.gawk}/bin/awk "/$NAME/{flag=1; next} flag && /\/dev\/video/{print $1; exit}" | ${pkgs.findutils}/bin/xargs)
          AUDIO_SOURCE=$(${pkgs.pulseaudio}/bin/pactl list sources short | ${pkgs.gawk}/bin/awk -v name="$NAME" 'BEGIN { gsub(/ /, "[ _]+", name) } tolower($2) ~ tolower(name) { print $2; exit }')

          if [ -z "$VIDEO_SOURCE" ]; then
              echo "Video device $NAME not found" >&2
              exit 1
          fi

          if [ -z "$AUDIO_SOURCE" ]; then
              echo "Audio device $NAME not found" >&2
              exit 1
          fi

          echo "Using video device $VIDEO_SOURCE at $RESOLUTION@$FPS and audio source $AUDIO_SOURCE"

          LOOPBACK_ID=$(${pkgs.pulseaudio}/bin/pactl load-module module-loopback source="$AUDIO_SOURCE" latency_msec=20)

          if [ -z "$LOOPBACK_ID" ]; then
              echo "Error: Failed to load pactl loopback module" >&2
              exit 1
          fi

          cleanup() {
              if [ -n "$MPV_PID" ]; then
                  kill -9 "$MPV_PID" 2>/dev/null
              fi
              if [ -n "$LOOPBACK_ID" ]; then
                  ${pkgs.pulseaudio}/bin/pactl unload-module "$LOOPBACK_ID" 2>/dev/null
              fi
          }
          trap cleanup EXIT INT TERM

          ${pkgs.mpv}/bin/mpv "av://v4l2:$VIDEO_SOURCE" \
              --demuxer-lavf-o=video_size=$RESOLUTION,framerate=$FPS,input_format=nv12 \
              --profile=low-latency \
              --untimed \
              --no-cache \
              --no-osc \
              --fs &
          MPV_PID=$!

          sleep 1

          if ! kill -0 "$MPV_PID" 2>/dev/null; then
              echo "Error: mpv failed to start or crashed immediately" >&2
              exit 1
          fi

          while kill -0 "$MPV_PID" 2>/dev/null; do
              sleep 0.1
          done

          echo "mpv exited, cleaning up..."
        '')
        (pkgs.makeDesktopItem {
          name = "capture";
          comment = "Capture video and audio from capture card";
          desktopName = "Capture";
          exec = "capture";
          icon = "video-display";
          categories = [ "AudioVideo" ];
        })
      ];
    };
}