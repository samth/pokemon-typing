#!/bin/bash
# Screenshot script for testing keyboard layout

OUTPUT="${1:-/tmp/typing-screenshot.png}"
URL="${2:-file://$(pwd)/index.html}"

echo "Taking screenshot of: $URL"
echo "Output: $OUTPUT"

google-chrome \
  --headless=new \
  --disable-gpu \
  --screenshot="$OUTPUT" \
  --window-size=1400,900 \
  --no-sandbox \
  "$URL" 2>&1 | grep -v "DevTools\|GPU\|vaapi"

sleep 2

if [ -f "$OUTPUT" ]; then
  echo "✓ Screenshot saved: $OUTPUT"
  ls -lh "$OUTPUT"
else
  echo "✗ Failed to create screenshot"
  exit 1
fi
