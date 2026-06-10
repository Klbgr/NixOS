{ pkgs, ... }:
pkgs.writeShellScriptBin "configuration-patcher" ''
  # --- JSON Merging ---
  patch_json() {
    local DEST_FILE="$1"
    local WANTED_JSON="$2"
    mkdir -p "$(dirname "$DEST_FILE")"

    if [ -f "$DEST_FILE" ]; then
      ${pkgs.yq-go}/bin/yq eval-all -p json -o json '. as $item ireduce ({}; . * $item )' "$DEST_FILE" <(echo "$WANTED_JSON") > "$DEST_FILE.tmp" && mv "$DEST_FILE.tmp" "$DEST_FILE"
    else
      echo "$WANTED_JSON" > "$DEST_FILE"
    fi
  }

  # --- YAML Merging ---
  patch_yaml() {
    local DEST_FILE="$1"
    local WANTED_YAML="$2"
    mkdir -p "$(dirname "$DEST_FILE")"

    if [ -f "$DEST_FILE" ]; then
      ${pkgs.yq-go}/bin/yq eval-all '. as $item ireduce ({}; . * $item )' "$DEST_FILE" <(echo "$WANTED_YAML") > "$DEST_FILE.tmp" && mv "$DEST_FILE.tmp" "$DEST_FILE"
    else
      echo "$WANTED_YAML" > "$DEST_FILE"
    fi
  }

  # --- TOML Merging ---
  patch_toml() {
    local DEST_FILE="$1"
    local WANTED_TOML="$2"
    mkdir -p "$(dirname "$DEST_FILE")"

    if [ -f "$DEST_FILE" ]; then
      ${pkgs.yq-go}/bin/yq eval-all -p toml -o toml '. as $item ireduce ({}; . * $item )' "$DEST_FILE" <(echo "$WANTED_TOML") > "$DEST_FILE.tmp" && mv "$DEST_FILE.tmp" "$DEST_FILE"
    else
      echo "$WANTED_TOML" > "$DEST_FILE"
    fi
  }

  # --- INI Merging ---
  patch_ini() {
    local DEST_FILE="$1"
    local WANTED_INI="$2"
    mkdir -p "$(dirname "$DEST_FILE")"

    if [ -f "$DEST_FILE" ]; then
      local EXISTING_JSON=$( ${pkgs.yq-go}/bin/yq -p ini -o json "$DEST_FILE" 2>/dev/null || echo '{}' )
      local WANTED_JSON=$( ${pkgs.yq-go}/bin/yq -p ini -o json <(echo "$WANTED_INI") )
      ${pkgs.yq-go}/bin/yq eval-all -p json -o ini '. as $item ireduce ({}; . * $item )' <(echo "$EXISTING_JSON") <(echo "$WANTED_JSON") > "$DEST_FILE.tmp" && mv "$DEST_FILE.tmp" "$DEST_FILE"
    else
      echo "$WANTED_INI" > "$DEST_FILE"
    fi
  }

  case "$1" in
    json) patch_json "$2" "$3" ;;
    yaml) patch_yaml "$2" "$3" ;;
    toml) patch_toml "$2" "$3" ;;
    ini)  patch_ini  "$2" "$3" ;;
    *) 
      echo "Usage:"
      echo "  configuration-patcher json <file> <json>"
      echo "  configuration-patcher yaml <file> <yaml>"
      echo "  configuration-patcher toml <file> <toml>"
      echo "  configuration-patcher ini  <file> <ini>"
      exit 1
      ;;
  esac
''
