#!/bin/bash
# iOS Run Script (run on macOS)
# Installs and launches the app on an iOS Simulator
# Requirements: macOS + Xcode + built app (run build.sh first)

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
IOS_DIR="$PROJECT_ROOT/ios"
BUILD_DIR="$IOS_DIR/build"
APP_PATH="$BUILD_DIR/Build/Products/Debug-iphonesimulator/HelloApp.app"
BUNDLE_ID="com.example.HelloApp"

echo "========================================"
echo "  iOS Run Script"
echo "========================================"
echo ""

# Verify app is built
if [ ! -d "$APP_PATH" ]; then
    echo "ERROR: App not found at $APP_PATH"
    echo "Run build.sh first: bash script/ios/build.sh"
    exit 1
fi

# Pick simulator: prefer booted, then first available iPhone
BOOTED_LINE=$(xcrun simctl list devices | grep -m1 'iPhone.*Booted' 2>/dev/null || true)
if [ -n "$BOOTED_LINE" ]; then
    SIM_ID=$(echo "$BOOTED_LINE" | sed 's/.*(\([A-F0-9-]*\)).*/\1/')
    SIM_NAME=$(echo "$BOOTED_LINE" | sed 's/^ *//' | sed 's/ *(.*//')
    echo "Using booted simulator: $SIM_NAME ($SIM_ID)"
else
    AVAIL_LINE=$(xcrun simctl list devices available | grep -m1 'iPhone' 2>/dev/null || true)
    if [ -z "$AVAIL_LINE" ]; then
        echo "ERROR: No iOS simulator available. Open Xcode and install a simulator."
        exit 1
    fi
    SIM_ID=$(echo "$AVAIL_LINE" | sed 's/.*(\([A-F0-9-]*\)).*/\1/')
    SIM_NAME=$(echo "$AVAIL_LINE" | sed 's/^ *//' | sed 's/ *(.*//')
    echo "Booting simulator: $SIM_NAME ($SIM_ID)"
    xcrun simctl boot "$SIM_ID"
fi

# Open Simulator app
open -a Simulator

# Wait for simulator to finish booting
echo "Waiting for simulator to be ready..."
ATTEMPTS=0
while [ $ATTEMPTS -lt 30 ]; do
    STATE=$(xcrun simctl list devices | grep "$SIM_ID" | sed 's/.*(\([^)]*\))$/\1/')
    if [ "$STATE" = "Booted" ]; then
        break
    fi
    sleep 1
    ATTEMPTS=$((ATTEMPTS + 1))
done

echo ""
echo "[1/2] Installing app: $APP_PATH"
xcrun simctl install "$SIM_ID" "$APP_PATH"

echo "[2/2] Launching app: $BUNDLE_ID"
xcrun simctl launch "$SIM_ID" "$BUNDLE_ID"

echo ""
echo "========================================"
echo "  App launched successfully!"
echo "========================================"
