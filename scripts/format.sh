#!/usr/bin/env bash
set -e

SWIFT_FORMAT=$(command -v swift-format || true)

if [ -z "$SWIFT_FORMAT" ]; then
  SWIFT_FORMAT=$(xcrun --find swift-format 2>/dev/null || true)
fi

if [ -z "$SWIFT_FORMAT" ]; then
  echo "swift-format not found in PATH or via xcrun"
  exit 1
fi

find . -type f -name "*.swift" \
  -not -path "./.build/*" \
  -not -path "./DerivedData/*" \
  -not -path "./Pods/*" \
  -print0 \
| xargs -0 "$SWIFT_FORMAT" -i --configuration .swift-format
