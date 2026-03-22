#!/bin/bash
# iOS Build Script (run on macOS)
# Requirements: macOS 12+, Xcode 14+, CocoaPods

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
IOS_DIR="$PROJECT_ROOT/ios"

echo "========================================"
echo "  iOS Build Script"
echo "========================================"
echo ""

# Sync code first
echo "[1/4] Syncing shared code..."
cd "$PROJECT_ROOT"
./sync-code.bat 2>/dev/null || ./sync-code.sh 2>/dev/null || true

cd "$IOS_DIR"

# Check for Xcode project
if [ ! -d "HelloApp.xcodeproj" ]; then
    echo "[2/4] Creating Xcode project..."
    echo "Please run the following commands in Xcode:"
    echo "  1. File > New > Project"
    echo "  2. Choose iOS > App"
    echo "  3. Product Name: HelloApp"
    echo "  4. Organization Identifier: com.example"
    echo "  5. Language: Swift"
    echo "  6. Save to: $IOS_DIR"
    echo ""
    echo "After creating the project, add the ArkTS files:"
    echo "  - Reference ets/pages/Index.ets"
    echo "  - Reference ets/entryability/EntryAbility.ts"
    echo ""
    echo "For ArkUI-X support, install the ArkUI-X SDK:"
    echo "  https://gitee.com/arkui-x/docs/blob/master/zh-cn/application-dev/quick-start/README.md"
    exit 1
fi

# Install CocoaPods dependencies
echo "[2/4] Installing CocoaPods dependencies..."
if [ -f "Podfile" ]; then
    pod install
fi

# Build
echo "[3/4] Building iOS app..."
if [ -d "HelloApp.xcworkspace" ]; then
    xcodebuild -workspace HelloApp.xcworkspace \
               -scheme HelloApp \
               -configuration Debug \
               -destination 'platform=iOS Simulator,name=iPhone 15'
else
    xcodebuild -project HelloApp.xcodeproj \
               -scheme HelloApp \
               -configuration Debug \
               -destination 'platform=iOS Simulator,name=iPhone 15'
fi

echo "[4/4] Build complete!"
echo ""
echo "========================================"
echo "  Build Success!"
echo "========================================"
echo ""
echo "To run on simulator:"
echo "  xcodebuild -workspace HelloApp.xcworkspace -scheme HelloApp -destination 'platform=iOS Simulator,name=iPhone 15'"
echo ""
echo "To run on device:"
echo "  Open HelloApp.xcworkspace in Xcode and press Cmd+R"
