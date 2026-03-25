#!/bin/bash
# Android Build and Run Script (run on macOS)

set -e

cd "$(dirname "$0")"

echo "========================================"
echo "  Android Build and Run Script"
echo "========================================"
echo ""

# Stage 1: Build
echo "[Stage 1] Building project..."
echo "========================================"
bash build.sh

echo ""
echo "[Stage 2] Installing and running..."
echo "========================================"
bash run.sh
