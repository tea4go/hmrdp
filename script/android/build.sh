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

# [1/4] 同步源代码
echo "[1/4] Syncing shared code..."
cd "$PROJECT_ROOT"
bash ./sync-code.sh
if [ $? -ne 0 ]; then
    echo "[Error] Code sync failed."
    exit 1
fi

# [2/4] 同步编译产物
echo "[2/4] Syncing HarmonyOS build artifacts..."
bash "$SCRIPT_DIR/sync-assets.sh"
if [ $? -ne 0 ]; then
    echo "[Error] Assets sync failed."
    echo "Please build HarmonyOS project first."
    exit 1
fi

# [3/4] 清理旧构建
echo "[3/4] Cleaning old build..."
if [ -d "$ANDROID_DIR/app/build" ]; then
    rm -rf "$ANDROID_DIR/app/build"
fi

# [4/4] 构建 APK
echo "[4/4] Building APK..."
cd "$ANDROID_DIR"

# 查找可用的 gradle 构建工具
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

echo ""
if [ $? -eq 0 ]; then
    echo "========================================"
    echo "  Build Success!"
    echo "========================================"
    echo ""
    echo "APK Location:"
    echo "  $ANDROID_DIR/app/build/outputs/apk/debug/app-debug.apk"
    echo ""
else
    echo "========================================"
    echo "  Build Failed! Check error messages."
    echo "========================================"
    echo ""
fi
