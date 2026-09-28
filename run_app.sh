#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")" && pwd)"
cd "$ROOT"

APP_ID="com.example.kuku_diary"
LAN_IP="$(hostname -I | awk '{print $1}')"
API_URL="${API_BASE_URL:-http://${LAN_IP}:8000/api}"
APK="$ROOT/build/app/outputs/flutter-apk/app-release.apk"

echo "Using API: $API_URL"

echo "Restarting ADB..."
adb kill-server >/dev/null 2>&1 || true
adb start-server >/dev/null
if ! timeout 20 adb wait-for-device; then
  echo "ERROR: no phone detected by adb (check the USB cable and that USB debugging is on)."
  exit 1
fi

# The Hisense sometimes shows as "device" but its adb daemon stops answering.
# Probe the shell; if it hangs, reconnect and probe again.
probe_shell() { timeout 8 adb shell echo ok 2>/dev/null | grep -q ok; }
if ! probe_shell; then
  echo "Phone is not responding to adb shell; reconnecting..."
  adb reconnect >/dev/null 2>&1 || true
  sleep 4
  adb wait-for-device
  if ! probe_shell; then
    echo "ERROR: adb shell still hangs. Unplug/replug the USB cable (or toggle USB debugging) and rerun."
    echo "Manual fallback: copy $APK to the phone and open it."
    exit 1
  fi
fi

echo "Building smaller arm64 APK (this is a one-time wait)..."
flutter build apk --release --target-platform android-arm64 \
  --dart-define="API_BASE_URL=$API_URL"

echo "Installing APK ($(du -h "$APK" | awk '{print $1}'))..."
cp -f "$APK" "$HOME/Desktop/KUKU-DIARY.apk" 2>/dev/null || true
# Streamed "adb install" hangs on this phone; push the file and let the phone install it instead.
if ! (timeout 120 adb push "$APK" /data/local/tmp/kuku.apk && timeout 120 adb shell pm install -r -d /data/local/tmp/kuku.apk); then
  echo "ERROR: install failed or timed out."
  echo "Manual fallback: copy ~/Desktop/KUKU-DIARY.apk to the phone and open it."
  exit 1
fi

echo "Launching app..."
adb shell am start -n "$APP_ID/.MainActivity" >/dev/null

echo
echo "App should be open on the phone."
echo "Keep the Django server running:"
echo "  cd backend && source .venv/bin/activate && python manage.py runserver 0.0.0.0:8000"
