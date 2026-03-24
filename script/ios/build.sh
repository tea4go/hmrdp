#!/bin/bash
# iOS Build Script (run on macOS)
# Requirements: macOS 12+, Xcode 14+, xcodegen

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
IOS_DIR="$PROJECT_ROOT/ios"
ARKUI_XCFRAMEWORK="$IOS_DIR/libarkui_ios.xcframework"

echo "========================================"
echo "  iOS Build Script"
echo "========================================"
echo ""

# Validate SDK
if [ ! -d "$ARKUI_XCFRAMEWORK" ]; then
    echo "ERROR: libarkui_ios.xcframework not found in $IOS_DIR"
    echo "Copy it from the ArkUI-X SDK: engine/xcframework/arkui/ios-release/libarkui_ios.xcframework"
    exit 1
fi

# Repair broken SDK packages that ship module.modulemap with `umbrella header "Ace.h"`
# but miss the actual Headers/Ace.h file.
create_ace_umbrella_if_missing() {
    local framework_dir="$1"
    local headers_dir="$framework_dir/Headers"
    local module_map="$framework_dir/Modules/module.modulemap"
    local ace_header="$headers_dir/Ace.h"

    if [ ! -f "$module_map" ] || [ ! -d "$headers_dir" ] || [ -f "$ace_header" ]; then
        return 0
    fi

    if grep -q 'umbrella header "Ace.h"' "$module_map"; then
        cat > "$ace_header" <<'EOF'
#ifndef LIBARKUI_IOS_ACE_H
#define LIBARKUI_IOS_ACE_H

#import "BridgeArray.h"
#import "BridgePlugin.h"
#import "BridgePluginManager.h"
#import "IArkUIXPlugin.h"
#import "IPlatformView.h"
#import "MethodData.h"
#import "PlatformViewFactory.h"
#import "PluginContext.h"
#import "ResultValue.h"
#import "StageApplication.h"
#import "StageViewController.h"
#import "TaskOption.h"

#endif /* LIBARKUI_IOS_ACE_H */
EOF
        echo "Patched missing umbrella header: $ace_header"
    fi
}

create_ace_umbrella_if_missing "$ARKUI_XCFRAMEWORK/ios-arm64/libarkui_ios.framework"
create_ace_umbrella_if_missing "$ARKUI_XCFRAMEWORK/ios-arm64_x86_64-simulator/libarkui_ios.framework"

# Sync code first
echo "[1/4] Syncing shared code..."
cd "$PROJECT_ROOT"
./sync-code.bat 2>/dev/null || ./sync-code.sh 2>/dev/null || true

cd "$IOS_DIR"

# Force default Xcode toolchain to avoid incompatible custom Swift toolchains.
unset TOOLCHAINS
unset SWIFT_EXEC
unset SWIFT_EXEC_TOOLCHAIN_DIR
unset SWIFT_DRIVER_SWIFT_FRONTEND_EXEC

# Generate Xcode project via xcodegen
echo "[2/4] Generating Xcode project..."
if ! command -v xcodegen &>/dev/null; then
    echo "ERROR: xcodegen not found. Install with: brew install xcodegen"
    exit 1
fi
xcodegen generate

# Install CocoaPods dependencies (only if Podfile has real entries)
if [ -f "Podfile" ]; then
    POD_COUNT=$(grep -v '^\s*#' Podfile | grep -c "pod '" || true)
    if [ "$POD_COUNT" -gt 0 ]; then
        pod install
    fi
fi

# Build
echo "[3/4] Building iOS app..."

# Prefer a booted simulator, fall back to first available iPhone
SIM_ID=$(xcrun simctl list devices | grep -m1 'iPhone.*Booted' | sed 's/.*(\([A-F0-9-]*\)).*/\1/' 2>/dev/null)
if [ -z "$SIM_ID" ]; then
    SIM_ID=$(xcrun simctl list devices available | grep -m1 'iPhone' | sed 's/.*(\([A-F0-9-]*\)).*/\1/' 2>/dev/null)
fi
if [ -n "$SIM_ID" ]; then
    SIM_DEST="platform=iOS Simulator,id=$SIM_ID"
else
    SIM_DEST="platform=iOS Simulator,name=iPhone 16"
fi

BUILD_DIR="$IOS_DIR/build"

xcodebuild -project HelloApp.xcodeproj \
           -scheme HelloApp \
           -configuration Debug \
           -destination "$SIM_DEST" \
           -derivedDataPath "$BUILD_DIR" \
           TOOLCHAINS=com.apple.dt.toolchain.XcodeDefault

APP_PATH="$BUILD_DIR/Build/Products/Debug-iphonesimulator/HelloApp.app"

echo "[4/4] Build complete!"
echo ""
echo "========================================"
echo "  Build Success!"
echo "========================================"
echo ""
echo "App: $APP_PATH"
echo ""
echo "Run: bash script/ios/run.sh"
