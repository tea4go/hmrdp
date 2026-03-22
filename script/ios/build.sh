#!/bin/bash
# iOS Build Script (run on macOS)

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

echo "========================================"
echo "  iOS Build Script"
echo "========================================"
echo ""

# Sync code first
echo "[1/2] Syncing shared code..."
cd "$PROJECT_ROOT"
./sync-code.sh

# Build
echo "[2/2] Building iOS app..."
cd "$PROJECT_ROOT/ios"

if [ -d "HelloApp.xcodeproj" ]; then
    xcodebuild -project HelloApp.xcodeproj -scheme HelloApp -configuration Debug -destination 'platform=iOS Simulator,name=iPhone 15'
    echo ""
    echo "========================================"
    echo "  Build Success!"
    echo "========================================"
else
    echo "[Warning] Xcode project not found."
    echo "Please open the project in Xcode manually."
fi
