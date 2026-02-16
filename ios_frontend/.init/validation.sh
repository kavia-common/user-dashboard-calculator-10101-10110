#!/usr/bin/env bash
set -euo pipefail
# This script executes the full validation: build, start, probe, stop and print evidence.
WORKSPACE="/home/kavia/workspace/code-generation/user-dashboard-calculator-10101-10110/ios_frontend"
export IOS_FRONTEND_API_URL="https://mock-api.local"
export IOS_FRONTEND_AUTH_TOKEN="test-token"
export IOS_FRONTEND_TEST_DB="/tmp/ios_frontend_test_$(date +%s).db"
cd "$WORKSPACE"
# Build
swift build -c debug || { echo "ERROR: build failed" >&2; exit 2; }
BIN_DIR=$(swift build --show-bin-path 2>/dev/null || echo ".build/debug")
DEMO_BIN="$BIN_DIR/demo"
if [ ! -x "$DEMO_BIN" ]; then
  echo "ERROR: demo binary not found at $DEMO_BIN" >&2
  exit 3
fi
OUTDIR=$(mktemp -d)
LOGFILE="$OUTDIR/demo.log"
# Start demo
"$DEMO_BIN" >"$LOGFILE" 2>&1 &
DEMO_PID=$!
# Wait a moment for startup
sleep 1
if ! kill -0 "$DEMO_PID" >/dev/null 2>&1; then
  echo "ERROR: demo did not start; log:" >&2
  tail -n 200 "$LOGFILE" >&2 || true
  rm -rf "$OUTDIR"
  exit 4
fi
echo "INFO: demo started pid=$DEMO_PID"
head -n 20 "$LOGFILE" || true
sleep 1
# Probe: simple health probe (process alive)
if kill -0 "$DEMO_PID" >/dev/null 2>&1; then
  echo "INFO: probe: process $DEMO_PID alive"
else
  echo "ERROR: probe failed; process not alive" >&2
  tail -n 200 "$LOGFILE" >&2 || true
  rm -rf "$OUTDIR"
  exit 5
fi
# Stop demo cleanly
kill -TERM "$DEMO_PID" || true
# wait up to 10s
WAIT=0
while kill -0 "$DEMO_PID" >/dev/null 2>&1 && [ $WAIT -lt 10 ]; do
  sleep 1; WAIT=$((WAIT+1))
done
if kill -0 "$DEMO_PID" >/dev/null 2>&1; then
  echo "WARN: demo did not exit after SIGTERM, sending SIGKILL" >&2
  kill -KILL "$DEMO_PID" || true
fi
# Evidence
echo "--- demo.log (last 50 lines) ---"
tail -n 50 "$LOGFILE" || true
echo "--- process status ---"
if ps -p "$DEMO_PID" >/dev/null 2>&1; then
  echo "ERROR: demo still running" >&2
  rm -rf "$OUTDIR"
  exit 6
else
  echo "OK: demo stopped"
fi
rm -rf "$OUTDIR"
exit 0
