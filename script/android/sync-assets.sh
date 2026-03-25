#!/bin/bash
# Sync HarmonyOS Build Artifacts to Android (run on macOS)

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
OHOS_BUILD="$PROJECT_ROOT/ohos/entry/build/default/intermediates/loader_out/default/ets"
ANDROID_ASSETS="$PROJECT_ROOT/android/app/src/main/assets/arkui-x/entry/ets"

echo "========================================"
echo "  Sync HarmonyOS Build Artifacts to Android"
echo "========================================"
echo ""

# 检查 HarmonyOS 编译输出
if [ ! -f "$OHOS_BUILD/modules.abc" ]; then
    echo "[Error] HarmonyOS build not found!"
    echo ""
    echo "Expected location:"
    echo "  $OHOS_BUILD/modules.abc"
    echo ""
    echo "Please build HarmonyOS project in DevEco Studio first:"
    echo "  1. Open DevEco Studio"
    echo "  2. Click Build > Build Hap(s)/APP(s) > Build Hap(s)"
    echo "  3. Wait for build to complete"
    echo "  4. Run this script again"
    exit 1
fi

# 确保目标目录存在
mkdir -p "$ANDROID_ASSETS"

# 同步 modules.abc
echo "[1/2] Syncing modules.abc..."
echo "  From: $OHOS_BUILD/modules.abc"
echo "  To:   $ANDROID_ASSETS/modules.abc"
cp -f "$OHOS_BUILD/modules.abc" "$ANDROID_ASSETS/modules.abc"
echo "  Done."

# 同步 sourceMaps.map（可选，不存在时跳过）
echo "[2/2] Syncing sourceMaps.map..."
if [ -f "$OHOS_BUILD/sourceMaps.map" ]; then
    echo "  From: $OHOS_BUILD/sourceMaps.map"
    echo "  To:   $ANDROID_ASSETS/sourceMaps.map"
    cp -f "$OHOS_BUILD/sourceMaps.map" "$ANDROID_ASSETS/sourceMaps.map"
    echo "  Done."
else
    echo "  [Skip] sourceMaps.map not found, skipping (debugging source maps unavailable)."
fi

echo ""
echo "========================================"
echo "  Assets Sync Complete!"
echo "========================================"
echo ""
echo "Synced files:"
echo "  ✓ modules.abc      - ArkTS bytecode"
if [ -f "$ANDROID_ASSETS/sourceMaps.map" ]; then
    echo "  ✓ sourceMaps.map   - Source map for debugging"
else
    echo "  ✗ sourceMaps.map   - Not available"
fi
echo ""
echo "File sizes:"
stat -f "  modules.abc: %z bytes" "$ANDROID_ASSETS/modules.abc" 2>/dev/null || \
    stat -c "  modules.abc: %s bytes" "$ANDROID_ASSETS/modules.abc" 2>/dev/null
if [ -f "$ANDROID_ASSETS/sourceMaps.map" ]; then
    stat -f "  sourceMaps.map: %z bytes" "$ANDROID_ASSETS/sourceMaps.map" 2>/dev/null || \
        stat -c "  sourceMaps.map: %s bytes" "$ANDROID_ASSETS/sourceMaps.map" 2>/dev/null
fi
echo ""
