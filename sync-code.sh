#!/bin/bash
# Sync shared code and compiled artifacts to all platforms (macOS)

set -e

PROJECT_ROOT="$(cd "$(dirname "$0")" && pwd)"
SOURCE_ETS="$PROJECT_ROOT/ohos/entry/src/main/ets"

# Compiled artifacts: prefer ohos build output, fallback to Android assets
OHOS_BUILD="$PROJECT_ROOT/ohos/entry/build/default/intermediates/loader_out/default"
ANDROID_ASSETS="$PROJECT_ROOT/android/app/src/main/assets/arkui-x"

echo "========================================"
echo "  Sync Shared Code to All Platforms"
echo "========================================"
echo ""
echo "Source: $SOURCE_ETS"
echo ""

# ── Step 1: Sync ArkTS source files ──────────────────────────────────────────

echo "[1/3] Syncing ETS source to Android..."
rm -rf "$PROJECT_ROOT/android/app/src/main/ets"
cp -r "$SOURCE_ETS" "$PROJECT_ROOT/android/app/src/main/ets"
echo "  Done."

echo "[2/3] Syncing ETS source to iOS..."
rm -rf "$PROJECT_ROOT/ios/HelloApp/ets"
cp -r "$SOURCE_ETS" "$PROJECT_ROOT/ios/HelloApp/ets"
echo "  Done."

# ── Step 2: Sync compiled artifacts to iOS arkui-x/ ──────────────────────────

echo "[3/3] Syncing compiled artifacts to iOS arkui-x/..."

IOS_ARKUIX="$PROJECT_ROOT/ios/HelloApp/arkui-x"

if [ -f "$OHOS_BUILD/ets/modules.abc" ]; then
    # Prefer freshly built HarmonyOS artifacts
    ARTIFACT_SOURCE="HarmonyOS build output"
    rm -rf "$IOS_ARKUIX/entry"
    mkdir -p "$IOS_ARKUIX/entry"
    cp -r "$OHOS_BUILD/ets" "$IOS_ARKUIX/entry/"
    cp -r "$ANDROID_ASSETS/entry/resources" "$IOS_ARKUIX/entry/" 2>/dev/null || true
    cp "$ANDROID_ASSETS/entry/module.json" "$IOS_ARKUIX/entry/" 2>/dev/null || true
    cp "$ANDROID_ASSETS/entry/resources.index" "$IOS_ARKUIX/entry/" 2>/dev/null || true
    # Sync systemres (required by ArkUI runtime)
    if [ -d "$ANDROID_ASSETS/systemres" ]; then
        rm -rf "$IOS_ARKUIX/systemres"
        cp -r "$ANDROID_ASSETS/systemres" "$IOS_ARKUIX/"
    fi
elif [ -f "$ANDROID_ASSETS/entry/ets/modules.abc" ]; then
    # Fallback to Android ArkUI-X compiled artifacts
    ARTIFACT_SOURCE="Android ArkUI-X assets"
    rm -rf "$IOS_ARKUIX/entry"
    mkdir -p "$IOS_ARKUIX/entry"
    cp -r "$ANDROID_ASSETS/entry/ets"       "$IOS_ARKUIX/entry/"
    cp -r "$ANDROID_ASSETS/entry/resources"  "$IOS_ARKUIX/entry/" 2>/dev/null || true
    cp "$ANDROID_ASSETS/entry/module.json"   "$IOS_ARKUIX/entry/" 2>/dev/null || true
    cp "$ANDROID_ASSETS/entry/resources.index" "$IOS_ARKUIX/entry/" 2>/dev/null || true
    # Sync systemres (required by ArkUI runtime)
    if [ -d "$ANDROID_ASSETS/systemres" ]; then
        rm -rf "$IOS_ARKUIX/systemres"
        cp -r "$ANDROID_ASSETS/systemres" "$IOS_ARKUIX/"
    fi
else
    echo "  WARNING: modules.abc not found. Build the ohos project in DevEco Studio first."
    echo "  Expected locations:"
    echo "    $OHOS_BUILD/ets/modules.abc"
    echo "    $ANDROID_ASSETS/entry/ets/modules.abc"
    echo ""
    echo "========================================"
    echo "  Sync Incomplete (no compiled artifacts)"
    echo "========================================"
    exit 1
fi

echo "  Source: $ARTIFACT_SOURCE"
echo "  Done."
echo ""
echo "========================================"
echo "  Sync Complete!"
echo "========================================"
