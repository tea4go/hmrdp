#!/bin/bash
# Android App Install and Run Script (run on macOS)
# Installs and launches the APK on a connected Android device/emulator
# Requirements: macOS, Android SDK (adb), built APK (run build.sh first)

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
APK_PATH="$PROJECT_ROOT/android/app/build/outputs/apk/debug/app-debug.apk"
PACKAGE_NAME="com.example.hmrdp"
ACTIVITY_NAME="com.hmrdp.EntryEntryAbilityActivity"

echo "========================================"
echo "  Android App Install and Run Script"
echo "========================================"
echo ""

# Detect Android SDK path
SDK_PATH=""
LOCAL_PROPS="$PROJECT_ROOT/android/local.properties"

if [ -f "$LOCAL_PROPS" ]; then
    SDK_PATH=$(grep "sdk.dir" "$LOCAL_PROPS" 2>/dev/null | cut -d= -f2 | sed 's|\\\\|/|g' | tr -d '[:space:]')
fi

# Fallback to common macOS SDK locations
if [ -z "$SDK_PATH" ]; then
    if [ -d "$HOME/Library/Android/sdk" ]; then
        SDK_PATH="$HOME/Library/Android/sdk"
    elif [ -n "$ANDROID_HOME" ] && [ -d "$ANDROID_HOME" ]; then
        SDK_PATH="$ANDROID_HOME"
    elif [ -n "$ANDROID_SDK_ROOT" ] && [ -d "$ANDROID_SDK_ROOT" ]; then
        SDK_PATH="$ANDROID_SDK_ROOT"
    fi
fi

# Set adb path
if [ -n "$SDK_PATH" ] && [ -f "$SDK_PATH/platform-tools/adb" ]; then
    ADB_EXE="$SDK_PATH/platform-tools/adb"
elif command -v adb &>/dev/null; then
    ADB_EXE="adb"
else
    echo "[Error] adb not found. Please install Android SDK platform-tools."
    echo "  brew install --cask android-platform-tools"
    exit 1
fi

# Check if APK exists
if [ ! -f "$APK_PATH" ]; then
    echo "[Error] APK file not found. Please run build.sh first."
    echo "  Expected: $APK_PATH"
    exit 1
fi

# Check device connection
echo "[1/3] Checking device connection..."
"$ADB_EXE" devices
echo ""

DEVICE_COUNT=$("$ADB_EXE" devices | grep -c -E '\t(device|emulator)')
if [ "$DEVICE_COUNT" -eq 0 ]; then
    echo "[Error] No Android device or emulator connected."
    echo "  Connect a device via USB or start an emulator."
    exit 1
fi

# Install APK
echo "[2/3] Installing app to device..."
echo "Please accept the installation on your device..."
"$ADB_EXE" install -r "$APK_PATH"
echo "Waiting for installation to complete (5 seconds)..."
sleep 5
echo ""

# Launch app
echo "[3/3] Launching app..."
"$ADB_EXE" shell am start -n "$PACKAGE_NAME/$ACTIVITY_NAME"

echo ""
echo "========================================"
echo "  App launched successfully!"
echo "========================================"
echo ""
