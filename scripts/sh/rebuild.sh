#!/usr/bin/env bash
# ============================================================================
# rebuild.sh
# Stops running servers and rebuilds TrinityCore
# ============================================================================
set -euo pipefail

DIR="$(cd "$(dirname "$0")/../.." && pwd)"

echo "========================================"
echo "   TrinityCore Rebuild Script"
echo "========================================"
echo

# Kill running servers
echo "[1/2] Stopping servers..."
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
echo "[2/2] Building project (Release)..."
echo
if ! cmake --build "$DIR/build" --config Release; then
    echo
    echo "========================================"
    echo "   BUILD FAILED!"
    echo "========================================"
    exit 1
fi
echo

echo "========================================"
echo "   Build completed successfully!"
echo "========================================"
