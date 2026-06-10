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
      ${pkgs.yq-go}/bin/yq eval-all -p ini -o ini '. as $item ireduce ({}; . * $item )' "$DEST_FILE" <(echo "$WANTED_INI") > "$DEST_FILE.tmp" && mv "$DEST_FILE.tmp" "$DEST_FILE"
    else
      echo "$WANTED_INI" > "$DEST_FILE"
    fi
  }

  # --- Legacy INI Merging ---
  patch_ini_legacy() {
    local DEST_FILE="$1"
    local SECTION="$2"
    local KEY="$3"
    local VALUE="$4"
    
    mkdir -p "$(dirname "$DEST_FILE")"
    touch "$DEST_FILE"

    local ESCAPED_VAL=$(echo "''${VALUE}" | sed 's/[\/&]/\\&/g')

    # Determine the search range
    local RANGE_START="1"
    local RANGE_END="$"
    
    if [ -n "''${SECTION}" ]; then
      # Ensure section exists
      if ! grep -q "^\[''${SECTION}\]$" "$DEST_FILE"; then
        echo -e "\n[''${SECTION}]" >> "$DEST_FILE"
      fi
      RANGE_START="/^\[''${SECTION}\]$/"
      RANGE_END="/^\[/"
    fi

    # Check if key exists in range
    if sed -n "''${RANGE_START},''${RANGE_END}p" "$DEST_FILE" | grep -q "^''${KEY}="; then
      # KEY EXISTS: Perform surgical replacement
      # We detect if the EXISTING line is a ByteArray to know if we need a multi-line range delete
      if sed -n "''${RANGE_START},''${RANGE_END}p" "$DEST_FILE" | grep "^''${KEY}=" | grep -q "@ByteArray"; then
          # Multi-line delete: from key to the first line ending in )"
          sed -i "''${RANGE_START},''${RANGE_END} { /^''${KEY}=/,/)\"$/ { /^''${KEY}=/ s|^.*$|''${KEY}=''${ESCAPED_VAL}|; //!d } }" "$DEST_FILE"
      else
          # Simple single-line replacement
          sed -i "''${RANGE_START},''${RANGE_END} s|^''${KEY}=.*|''${KEY}=''${ESCAPED_VAL}|" "$DEST_FILE"
      fi
    else
      # KEY MISSING: Insert
      if [ -z "''${SECTION}" ]; then
        echo "''${KEY}=''${VALUE}" >> "$DEST_FILE"
      else
        sed -i "/^\[''${SECTION}\]$/a ''${KEY}=''${VALUE}" "$DEST_FILE"
      fi
    fi
  }

  case "$1" in
    json) patch_json "$2" "$3" ;;
    yaml) patch_yaml "$2" "$3" ;;
    toml) patch_toml "$2" "$3" ;;
    ini)  patch_ini  "$2" "$3" ;;
    ini-legacy) patch_ini_legacy "$2" "$3" "$4" "$5" ;;
    *) 
      echo "Usage:"
      echo "  configuration-patcher json <file> <json>"
      echo "  configuration-patcher yaml <file> <yaml>"
      echo "  configuration-patcher toml <file> <toml>"
      echo "  configuration-patcher ini  <file> <ini>"
      echo "  configuration-patcher ini-legacy <file> <section> <key> <value>"
      exit 1
      ;;
  esac
''
