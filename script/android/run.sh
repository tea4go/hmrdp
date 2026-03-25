#!/bin/bash
# Android App Install and Run Script (run on macOS)
# Installs and launches the APK on a connected Android device/emulator
# Requirements: macOS, Android SDK (adb, emulator), built APK (run build.sh first)

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

# Set emulator path
EMULATOR_EXE=""
if [ -n "$SDK_PATH" ] && [ -f "$SDK_PATH/emulator/emulator" ]; then
    EMULATOR_EXE="$SDK_PATH/emulator/emulator"
elif command -v emulator &>/dev/null; then
    EMULATOR_EXE="emulator"
fi

# Check if APK exists
if [ ! -f "$APK_PATH" ]; then
    echo "[Error] APK file not found. Please run build.sh first."
    echo "  Expected: $APK_PATH"
    exit 1
fi

# Pick device/emulator: prefer running device, then boot an emulator
echo "[1/3] Checking device connection..."
DEVICE_COUNT=$("$ADB_EXE" devices | grep -c -E '\t(device|emulator)' || true)

if [ "$DEVICE_COUNT" -gt 0 ]; then
    DEVICE_LINE=$("$ADB_EXE" devices | grep -m1 -E '\t(device|emulator)')
    DEVICE_ID=$(echo "$DEVICE_LINE" | awk '{print $1}')
    echo "Using connected device: $DEVICE_ID"
else
    echo "No running device or emulator found."
    # Try to start an emulator
    if [ -z "$EMULATOR_EXE" ]; then
        echo "[Error] emulator command not found. Cannot auto-start."
        echo "  Connect a device via USB or start an emulator manually."
        exit 1
    fi

    # List available AVDs
    AVDS=$("$EMULATOR_EXE" -list-avds 2>/dev/null || true)
    if [ -z "$AVDS" ]; then
        echo "[Error] No AVDs available. Create one in Android Studio first."
        echo "  Android Studio > Tools > Device Manager > Create Virtual Device"
        exit 1
    fi

    AVD_NAME=$(echo "$AVDS" | head -1)
    echo "Booting emulator: $AVD_NAME"
    "$EMULATOR_EXE" -avd "$AVD_NAME" -no-snapshot-load &
    EMULATOR_PID=$!

    # Wait for emulator to be ready
    echo "Waiting for emulator to boot..."
    ATTEMPTS=0
    while [ $ATTEMPTS -lt 60 ]; do
        BOOT_COMPLETE=$("$ADB_EXE" shell getprop sys.boot_completed 2>/dev/null | tr -d '\r' || true)
        if [ "$BOOT_COMPLETE" = "1" ]; then
            break
        fi
        sleep 2
        ATTEMPTS=$((ATTEMPTS + 1))
    done

    if [ "$BOOT_COMPLETE" != "1" ]; then
        echo "[Error] Emulator failed to boot within 120 seconds."
        kill "$EMULATOR_PID" 2>/dev/null || true
        exit 1
    fi

    DEVICE_ID=$("$ADB_EXE" devices | grep -m1 -E '\t(device|emulator)' | awk '{print $1}')
    echo "Emulator ready: $DEVICE_ID"
fi
echo ""

# Install APK
echo "[2/3] Installing app..."
"$ADB_EXE" -s "$DEVICE_ID" install -r "$APK_PATH"
echo ""

# Launch app
echo "[3/3] Launching app..."
"$ADB_EXE" -s "$DEVICE_ID" shell am start -n "$PACKAGE_NAME/$ACTIVITY_NAME"

echo ""
echo "========================================"
echo "  App launched successfully!"
echo "========================================"
echo ""
