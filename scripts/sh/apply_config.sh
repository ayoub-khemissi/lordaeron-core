#!/usr/bin/env bash
# ============================================================================
# apply_config.sh
# Reads worldserver.init and applies each setting onto worldserver.conf.
# If worldserver.conf doesn't exist, it is copied from worldserver.conf.dist.
#
# Supports two layouts:
#   1. Installed server  — e.g. ~/server/{bin,etc}
#   2. Build output      — e.g. lordaeron-core/build/bin/RelWithDebInfo/{bin,etc}
#
# Usage:
#   ./apply_config.sh                 # auto-detect from repo root
#   ./apply_config.sh /path/to/server # explicit server directory
# ============================================================================
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"

# ── Resolve server directory ────────────────────────────────────────────────

resolve_server_dir() {
    # 1. Explicit argument
    if [[ -n "${1:-}" && -f "$1/bin/worldserver" ]]; then
        echo "$1"
        return
    fi

    # 2. Build output (RelWithDebInfo or Release)
    for variant in RelWithDebInfo Release; do
        local candidate="$ROOT/build/bin/$variant"
        if [[ -f "$candidate/bin/worldserver" ]]; then
            echo "$candidate"
            return
        fi
    done

    # 3. Default install location
    if [[ -f "$HOME/server/bin/worldserver" ]]; then
        echo "$HOME/server"
        return
    fi

    return 1
}

SERVER_DIR="$(resolve_server_dir "${1:-}")" || {
    echo "[ERROR] Could not find worldserver. Searched:"
    echo "  - Build output: $ROOT/build/bin/{Release,RelWithDebInfo}/bin/"
    echo "  - Default:      $HOME/server/bin/"
    echo "  Tip: pass the server root as argument: $0 /path/to/server"
    exit 1
}

BIN_DIR="$SERVER_DIR/bin"
ETC_DIR="$SERVER_DIR/etc"

# ── Locate worldserver.init ─────────────────────────────────────────────────

INIT_FILE="$BIN_DIR/worldserver.init"
if [[ ! -f "$INIT_FILE" ]]; then
    # Fallback: repo root (before make install copies it)
    INIT_FILE="$ROOT/worldserver.init"
fi
if [[ ! -f "$INIT_FILE" ]]; then
    echo "[ERROR] worldserver.init not found in $BIN_DIR or $ROOT"
    exit 1
fi

# ── Locate / create worldserver.conf ────────────────────────────────────────

CONF_FILE="$ETC_DIR/worldserver.conf"
if [[ ! -f "$CONF_FILE" ]]; then
    if [[ -f "$ETC_DIR/worldserver.conf.dist" ]]; then
        echo "worldserver.conf not found, copying from worldserver.conf.dist..."
        cp "$ETC_DIR/worldserver.conf.dist" "$CONF_FILE"
    else
        echo "[ERROR] Neither worldserver.conf nor worldserver.conf.dist found in $ETC_DIR"
        exit 1
    fi
fi

# ── Apply settings ──────────────────────────────────────────────────────────

echo "Server directory : $SERVER_DIR"
echo "Init file        : $INIT_FILE"
echo "Config file      : $CONF_FILE"
echo
echo "Applying settings..."
echo

count=0
while IFS= read -r line; do
    # Trim whitespace
    line="$(echo "$line" | xargs)"

    # Skip empty lines and comments
    [[ -z "$line" || "$line" == \#* ]] && continue

    if [[ "$line" =~ ^([A-Za-z0-9_.]+)[[:space:]]*=[[:space:]]*(.*)$ ]]; then
        key="${BASH_REMATCH[1]}"
        val="$(echo "${BASH_REMATCH[2]}" | xargs)"
        escaped_key="$(printf '%s' "$key" | sed 's/[.[\*^$()+?{|\\]/\\&/g')"

        if grep -qE "^${escaped_key}\s*=" "$CONF_FILE"; then
            sed -i "s|^\(${escaped_key}\s*=\s*\).*$|\1${val}|" "$CONF_FILE"
            echo "  [OK]   $key = $val"
            count=$((count + 1))
        else
            echo "  [SKIP] $key not found in worldserver.conf"
        fi
    fi
done < "$INIT_FILE"

echo
echo "$count setting(s) applied."
