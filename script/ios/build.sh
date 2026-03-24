#!/bin/bash
# iOS Build Script (run on macOS)
# Requirements: macOS 12+, Xcode 14+, xcodegen

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
IOS_DIR="$PROJECT_ROOT/ios"

echo "========================================"
echo "  iOS Build Script"
echo "========================================"
echo ""

# Validate SDK
if [ ! -d "$IOS_DIR/libarkui_ios.xcframework" ]; then
    echo "ERROR: libarkui_ios.xcframework not found in $IOS_DIR"
    echo "Copy it from the ArkUI-X SDK: engine/xcframework/arkui/ios-release/libarkui_ios.xcframework"
    exit 1
fi

# Sync code first
echo "[1/4] Syncing shared code..."
cd "$PROJECT_ROOT"
./sync-code.bat 2>/dev/null || ./sync-code.sh 2>/dev/null || true

cd "$IOS_DIR"

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
SIM_DEST=$(xcrun simctl list devices available | grep -m1 'iPhone' | sed 's/.*(\(.*\)) (.*/\1/' | xargs -I{} echo "platform=iOS Simulator,id={}" 2>/dev/null || echo "platform=iOS Simulator,name=iPhone 16")

xcodebuild -project HelloApp.xcodeproj \
           -scheme HelloApp \
           -configuration Debug \
           -destination "$SIM_DEST"

echo "[4/4] Build complete!"
echo ""
echo "========================================"
echo "  Build Success!"
echo "========================================"
echo ""
echo "To run on simulator:"
echo "  xcodebuild -project HelloApp.xcodeproj -scheme HelloApp -destination 'platform=iOS Simulator,name=iPhone 16'"
echo ""
echo "To run on device:"
echo "  Open HelloApp.xcworkspace in Xcode and press Cmd+R"
