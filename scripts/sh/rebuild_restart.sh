#!/usr/bin/env bash
# ============================================================================
# rebuild_restart.sh
# Stops running servers, rebuilds TrinityCore, then starts servers again
# ============================================================================
set -euo pipefail

DIR="$(cd "$(dirname "$0")/../.." && pwd)"

echo "========================================"
echo "   TrinityCore Rebuild + Restart Script"
echo "========================================"
echo

# Kill running servers
echo "[1/4] Stopping servers..."
if pkill -f authserver 2>/dev/null; then
    echo "      authserver stopped"
else
    echo "      authserver was not running"
fi
if pkill -f worldserver 2>/dev/null; then
    echo "      worldserver stopped"
else
    echo "      worldserver was not running"
fi
echo

# Build the project
echo "[2/4] Building project (Release)..."
echo
if ! cmake --build "$DIR/build" --config Release; then
    echo
    echo "========================================"
    echo "   BUILD FAILED!"
    echo "========================================"
    exit 1
fi
echo

echo "[3/4] Build successful!"
echo

# Find the output directory
BIN_DIR="$DIR/build/bin/Release"
if [[ ! -f "$BIN_DIR/worldserver" ]]; then
    BIN_DIR="$DIR/build/bin/RelWithDebInfo"
fi
if [[ ! -f "$BIN_DIR/worldserver" ]]; then
    echo "ERROR: Could not find worldserver in build output"
    exit 1
fi

# Start servers
echo "[4/4] Starting servers from $BIN_DIR..."
cd "$BIN_DIR"
./authserver &
echo "      authserver started"
sleep 2
./worldserver &
echo "      worldserver started"
echo

echo "========================================"
echo "   Done!"
echo "========================================"
