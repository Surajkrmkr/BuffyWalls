#!/usr/bin/env bash
# Run BuffyWalls on a connected Android device against local data, with
# test ads. Usage: tools/dev/run_dev.sh [extra flutter run args]
#
#  - starts tools/dev/dev_server.py (local copy of the GitLab data)
#  - forwards the port to the phone with `adb reverse`
#  - points .env at it for the run, and restores .env on exit
#  - passes the AdMob test-device id so no live ads are served
set -euo pipefail
cd "$(dirname "$0")/../.."

PORT="${PORT:-8765}"
TEST_ID="${ADMOB_TEST_DEVICE_ID:-40F664107B55990F67B83DA648738CCD}"

cp .env .env.pre-dev 2>/dev/null || true
cleanup() {
  [[ -n "${SERVER_PID:-}" ]] && kill "$SERVER_PID" 2>/dev/null || true
  adb reverse --remove "tcp:$PORT" >/dev/null 2>&1 || true
  [[ -f .env.pre-dev ]] && mv .env.pre-dev .env
}
trap cleanup EXIT

PORT="$PORT" python3 tools/dev/dev_server.py &
SERVER_PID=$!
sleep 1
adb reverse "tcp:$PORT" "tcp:$PORT"

# Same keys the CI writes; free/paid flags only decide the free flavour.
cat > .env <<ENV
BUFFY=free
FREE=free
PAID=paid
URL=http://127.0.0.1:$PORT/buffy.json
ONBOARD_URL=http://127.0.0.1:$PORT/startup.json
ENV

flutter run --flavor free \
  --dart-define=ADMOB_TEST_DEVICE_ID="$TEST_ID" \
  --dart-define=ALLOW_SCREENSHOTS=true "$@"
