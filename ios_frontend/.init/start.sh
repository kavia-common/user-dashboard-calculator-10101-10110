#!/usr/bin/env bash
set -euo pipefail
WORKSPACE="/home/kavia/workspace/code-generation/user-dashboard-calculator-10101-10110/ios_frontend"
export IOS_FRONTEND_API_URL="https://mock-api.local"
export IOS_FRONTEND_AUTH_TOKEN="test-token"
export IOS_FRONTEND_TEST_DB="/tmp/ios_frontend_test_$(date +%s).db"
cd "$WORKSPACE"
BIN_DIR=$(swift build --show-bin-path 2>/dev/null || echo ".build/debug")
DEMO_BIN="$BIN_DIR/demo"
if [ ! -x "$DEMO_BIN" ]; then
  echo "ERROR: demo binary not found at $DEMO_BIN" >&2
  exit 3
fi
OUTDIR=$(mktemp -d)
LOGFILE="$OUTDIR/demo.log"
# Start demo binary directly and print PID and logfile path
"$DEMO_BIN" >"$LOGFILE" 2>&1 &
DEMO_PID=$!
# Persist pid and logfile for stop script
echo "$DEMO_PID" >"$OUTDIR/demo.pid"
echo "$LOGFILE" >"$OUTDIR/demo.logpath"
# Expose OUTDIR location for caller
echo "$OUTDIR"
