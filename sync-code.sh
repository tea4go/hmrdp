#!/bin/bash
# 同步共享代码到各平台目录
# 用法: ./sync-code.sh

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SOURCE_DIR="$SCRIPT_DIR/ohos/entry/src/main/ets"

echo "========================================"
echo "  同步 ArkUI-X 共享代码"
echo "========================================"
echo ""
echo "源目录: $SOURCE_DIR"
echo ""

# 同步到 Android
echo "[1/2] 同步到 Android..."
rm -rf "$SCRIPT_DIR/android/app/src/main/ets"
cp -r "$SOURCE_DIR" "$SCRIPT_DIR/android/app/src/main/ets"
echo "  ✓ Android 同步完成"

# 同步到 iOS
echo "[2/2] 同步到 iOS..."
rm -rf "$SCRIPT_DIR/ios/HelloApp/ets"
cp -r "$SOURCE_DIR" "$SCRIPT_DIR/ios/HelloApp/ets"
echo "  ✓ iOS 同步完成"

echo ""
echo "========================================"
echo "  同步完成!"
echo "========================================"
echo ""
echo "已同步目录:"
echo "  - android/app/src/main/ets/"
echo "  - ios/HelloApp/ets/"
echo ""
