#!/bin/bash
# Screenshot script for testing

# Parse arguments
TEST_MODE=""
OUTPUT="/tmp/typing-screenshot.png"
BASE_URL="file://$(pwd)/index.html"

# Quick test modes
case "$1" in
  long|short|advanced)
    TEST_MODE="$1"
    OUTPUT="/tmp/test-$1.png"
    ;;
  *)
    [ -n "$1" ] && OUTPUT="$1"
    [ -n "$2" ] && BASE_URL="$2"
    ;;
esac

# Build URL with test parameters
URL="$BASE_URL"
[ "$TEST_MODE" = "long" ] && URL="$BASE_URL?test=long"
[ "$TEST_MODE" = "short" ] && URL="$BASE_URL?test=short"
[ "$TEST_MODE" = "advanced" ] && URL="$BASE_URL?advanced=true"

echo "📸 Screenshot: $OUTPUT"

google-chrome \
  --headless=new \
  --disable-gpu \
  --screenshot="$OUTPUT" \
  --window-size=1400,900 \
  --no-sandbox \
  --virtual-time-budget=10000 \
  "$URL" 2>&1 | grep -v "DevTools\|GPU\|vaapi" || true

sleep 1

if [ -f "$OUTPUT" ]; then
  echo "✓ Saved $(du -h "$OUTPUT" | cut -f1)"
  [ -n "$DISPLAY" ] && which feh &>/dev/null && feh "$OUTPUT" &
else
  echo "✗ Failed"
  exit 1
fi
