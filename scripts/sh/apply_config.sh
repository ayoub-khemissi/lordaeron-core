#!/usr/bin/env bash
# ============================================================================
# apply_config.sh
# Reads worldserver.init and applies properties onto worldserver.conf
# If worldserver.conf doesn't exist, it is copied from worldserver.conf.dist
# Both files are expected in the build output directory.
# ============================================================================
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"

# Locate build output directory
DIR="$ROOT/build/bin/Release"
if [[ ! -f "$DIR/worldserver" ]]; then
    DIR="$ROOT/build/bin/RelWithDebInfo"
fi
if [[ ! -f "$DIR/worldserver" ]]; then
    echo "[ERROR] Could not find worldserver in build output"
    exit 1
fi

if [[ ! -f "$DIR/worldserver.init" ]]; then
    echo "[ERROR] worldserver.init not found in $DIR"
    exit 1
fi

if [[ ! -f "$DIR/worldserver.conf" ]]; then
    if [[ -f "$DIR/worldserver.conf.dist" ]]; then
        echo "worldserver.conf not found, copying from worldserver.conf.dist..."
        cp "$DIR/worldserver.conf.dist" "$DIR/worldserver.conf"
    else
        echo "[ERROR] worldserver.conf not found in $DIR"
        exit 1
    fi
fi

echo "Applying worldserver.init onto worldserver.conf in $DIR..."
echo

count=0
while IFS= read -r line; do
    line="$(echo "$line" | xargs)"
    [[ -z "$line" || "$line" == \#* ]] && continue

    if [[ "$line" =~ ^([A-Za-z0-9_.]+)[[:space:]]*=[[:space:]]*(.*)$ ]]; then
        key="${BASH_REMATCH[1]}"
        val="$(echo "${BASH_REMATCH[2]}" | xargs)"
        escaped_key="$(printf '%s' "$key" | sed 's/[.[\*^$()+?{|\\]/\\&/g')"

        if grep -qE "^${escaped_key}\s*=" "$DIR/worldserver.conf"; then
            sed -i "s|^\(${escaped_key}\s*=\s*\).*$|\1${val}|" "$DIR/worldserver.conf"
            echo "  [OK] $key = $val"
            ((count++))
        else
            echo "  [SKIP] $key not found in worldserver.conf"
        fi
    fi
done < "$DIR/worldserver.init"

echo
echo "$count property(ies) updated."
