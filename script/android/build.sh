#!/bin/bash
# Android APK Build Script (run on macOS)
# Requirements: macOS, Android SDK, Java 11+, DevEco Studio (for HarmonyOS build)

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
ANDROID_DIR="$PROJECT_ROOT/android"

echo "========================================"
echo "  Android APK Build Script"
echo "========================================"
echo ""

# Build HarmonyOS module to get fresh modules.abc
echo "[1/5] Building HarmonyOS module (compiling ArkTS)..."
HVIGORW=""
if command -v hvigorw &>/dev/null; then
    HVIGORW="hvigorw"
elif [ -f "/Applications/DevEco-Studio.app/Contents/tools/hvigor/bin/hvigorw" ]; then
    HVIGORW="/Applications/DevEco-Studio.app/Contents/tools/hvigor/bin/hvigorw"
fi

if [ -n "$HVIGORW" ]; then
    cd "$PROJECT_ROOT/ohos"
    "$HVIGORW" --no-daemon -p product=default -p module=entry@default assembleHap \
        --analyze=normal --parallel --incremental
    cd "$PROJECT_ROOT"
    echo "  HarmonyOS build done."
else
    echo "  WARNING: hvigorw not found, skipping HarmonyOS build."
    echo "  modules.abc may be stale — build manually in DevEco Studio first."
fi

# Sync shared code (ETS source → android/)
echo "[2/5] Syncing shared code..."
cd "$PROJECT_ROOT"
bash ./sync-code.sh

# Sync compiled artifacts (modules.abc → android assets)
echo "[3/5] Syncing HarmonyOS build artifacts..."
bash "$SCRIPT_DIR/sync-assets.sh"

# Clean old build
echo "[4/5] Cleaning old build..."
if [ -d "$ANDROID_DIR/app/build" ]; then
    rm -rf "$ANDROID_DIR/app/build"
fi

# Build APK
echo "[5/5] Building APK..."
cd "$ANDROID_DIR"

if [ -f "$ANDROID_DIR/gradlew" ]; then
    GRADLE_CMD="$ANDROID_DIR/gradlew"
elif command -v gradle &>/dev/null; then
    GRADLE_CMD="gradle"
else
    echo "[Error] No gradle found."
    echo "Please install gradle or create gradlew in the android directory."
    exit 1
fi

chmod +x "$GRADLE_CMD" 2>/dev/null || true
"$GRADLE_CMD" assembleDebug

APK_PATH="$ANDROID_DIR/app/build/outputs/apk/debug/app-debug.apk"

echo ""
echo "========================================"
echo "  Build Success!"
echo "========================================"
echo ""
echo "APK: $APK_PATH"
echo ""
echo "Run: bash script/android/run.sh"
